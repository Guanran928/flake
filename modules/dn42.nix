{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.networking.dn42;
in
{
  options = {
    networking.dn42 = {
      enable = lib.mkEnableOption "";
      asn = lib.mkOption { type = lib.types.str; };
      address = lib.mkOption { type = lib.types.str; };
      cidr = lib.mkOption { type = lib.types.str; };
      wgPrivkey = lib.mkOption { type = lib.types.str; };
      lgPort = lib.mkOption { type = lib.types.int; };

      community = {
        region = lib.mkOption { type = lib.types.int; };
        country = lib.mkOption { type = lib.types.int; };
      };

      peers = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              asn = lib.mkOption {
                type = lib.types.str;
                example = "424242999";
              };

              address = lib.mkOption {
                type = lib.types.str;
                example = "fd36:62be:ef51:1::1";
              };

              wireguard = {
                endpoint = lib.mkOption {
                  type = lib.types.str;
                  example = "tyo.node.cowgl.xyz:30021";
                };

                pubkey = lib.mkOption {
                  type = lib.types.str;
                  example = "mMGGxtEqsagrx1Raw57C2H3Stl6ch/cUuF7y08eVgBE=";
                };

                listenPort = lib.mkOption {
                  type = lib.types.str;
                  example = "23999";
                };
              };
            };
          }
        );

        default = [ ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.networking.firewall.enable;
        message = "The DN42 module currently requires `networking.firewall.enable` to be disabled.";
      }
      {
        assertion = config.networking.useNetworkd && !config.networking.useDHCP;
        message = "The DN42 module currently requires `networking.useNetworkd` to be enabled and `networking.useDHCP` to be disabled.";
      }
    ];

    ################################################
    #                   Tunnel                     #
    ################################################
    systemd.network.netdevs =
      let
        toNetdev =
          peer:
          lib.nameValuePair "50-wg${peer.asn}" {
            netdevConfig = {
              Kind = "wireguard";
              Name = "wg${peer.asn}";
            };
            wireguardConfig = {
              PrivateKeyFile = cfg.wgPrivkey;
              ListenPort = peer.wireguard.listenPort;
            };
            wireguardPeers = [
              {
                PublicKey = peer.wireguard.pubkey;
                Endpoint = peer.wireguard.endpoint;
                AllowedIPs = [
                  "0.0.0.0/0"
                  "fe80::/64"
                  "fd00::/8"
                ];
              }
            ];
          };
      in
      lib.listToAttrs (map toNetdev cfg.peers);

    systemd.network.networks =
      let
        toNetwork =
          peer:
          lib.nameValuePair "50-wg${peer.asn}" {
            matchConfig.Name = "wg${peer.asn}";
            addresses = [
              {
                Address = "${cfg.address}/128";
                Peer = "${peer.address}/128";
              }
            ];

            dns = [
              "fd42:d42:d42:54::1"
              "fd42:d42:d42:53::1"
            ];

            domains = [ "~dn42" ];

            networkConfig = {
              IPv6AcceptRA = false;
              IPv6Forwarding = true;
              DHCP = false;
              KeepConfiguration = true;
            };
          };
      in
      lib.listToAttrs (map toNetwork cfg.peers);

    ################################################
    #                     BGP                      #
    ################################################
    services.bird = {
      enable = true;
      checkConfig = false;
      config = ''
        # Variable header
        define OWNAS =  ${cfg.asn};
        define OWNIPv6 = ${cfg.address};
        define OWNNETv6 = ${cfg.cidr};
        define OWNNETSETv6 = [ ${cfg.cidr}+ ];
        define DN42_REGION = ${toString cfg.community.region};
        define DN42_COUNTRY = ${toString cfg.community.country};

        protocol device {
            scan time 10;
        }

        /*
         *  Utility functions
         */

        function is_self_net_v6() -> bool {
          return net ~ OWNNETSETv6;
        }

        function is_valid_network_v6() -> bool {
          return net ~ [
            fd00::/8{44,64} # ULA address space as per RFC 4193
          ];
        }

        function ebgp_calculate_priority() -> int {
          int ebgp_priority = 100;

          if bgp_community ~ [(64511, DN42_REGION)] then
              ebgp_priority = ebgp_priority + 10;

          if bgp_community ~ [(64511, DN42_COUNTRY)] then
              ebgp_priority = ebgp_priority + 5;

          if bgp_path.len = 1 then
              ebgp_priority = ebgp_priority + 20;

          return ebgp_priority;
        }


        roa6 table dn42_roa_v6;

        protocol static {
          roa6 { table dn42_roa_v6; };
          include "/run/bird/roa_dn42_v6.conf";
        };


        protocol kernel {
          scan time 20;

          ipv6 {
            import none;
            export filter {
              if source = RTS_STATIC then reject;
              krt_prefsrc = OWNIPv6;
              accept;
            };
          };
        };

        protocol static {
          route OWNNETv6 reject;

          ipv6 {
            import all;
            export none;
          };
        }

        template bgp dnpeers {
          local as OWNAS;
          path metric 1;

          ipv6 {
            import filter {
              if is_valid_network_v6() && !is_self_net_v6() then {
                if (roa_check(dn42_roa_v6, net, bgp_path.last) != ROA_VALID) then {
                  # Reject when unknown or invalid according to ROA
                  print "[dn42] ROA check failed for ", net, " ASN ", bgp_path.last;
                  reject;
                } else accept;
              } else reject;
            };
            export filter {
              if is_valid_network_v6() && source ~ [RTS_STATIC, RTS_BGP] then {
                if is_self_net_v6() then {
                  bgp_community.add((64511, DN42_REGION));
                  bgp_community.add((64511, DN42_COUNTRY));
                }
                accept;
              } else reject;
            };
            import limit 9000 action block;
          };
        }

        include "/etc/bird/peers/*";
      '';
    };

    systemd.services.bird = {
      reloadTriggers = map (peer: "/etc/bird/peers/${peer.asn}.conf") cfg.peers;
      serviceConfig.RuntimeDirectory = [ "bird" ];
      preStart = "${lib.getExe pkgs.curl} -o /run/bird/roa_dn42_v6.conf https://dn42.burble.com/roa/dn42_roa_bird2_6.conf";
    };

    environment.etc =
      let
        toFile =
          peer:
          lib.nameValuePair "bird/peers/${peer.asn}.conf" {
            text = ''
              protocol bgp dn42_${peer.asn}_v6 from dnpeers {
                neighbor ${peer.address}%wg${peer.asn} as ${peer.asn};
              };
            '';
          };
      in
      lib.listToAttrs (map toFile cfg.peers);

    ################################################
    #                Looking Glass                 #
    ################################################
    services.bird-lg.proxy = {
      enable = true;
      listenAddresses = "[::]:${toString cfg.lgPort}";
    };
  };
}
