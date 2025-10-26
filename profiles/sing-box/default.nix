{
  lib,
  pkgs,
  config,
  ...
}:
{
  services.sing-box = {
    enable = true;
    settings = {
      log = {
        level = "warn";
      };

      dns = {
        servers = [
          {
            type = "tls";
            tag = "cloudflare";
            server = "[2606:4700:4700::1111]";
          }
          {
            type = "local";
            tag = "local";
          }
        ];

        strategy = "prefer_ipv6";
        final = "cloudflare";
      };

      inbounds = lib.singleton {
        type = "http";
        tag = "inbound";
        listen = "127.0.0.1";
        listen_port = 1080;
      };

      outbounds = [
        {
          type = "vless";
          tag = "tyo0";
          server = "tyo0.ny4.dev";
          server_port = 27253;
          uuid._secret = config.sops.secrets."sing-box/uuid".path;
          flow = "xtls-rprx-vision";
          tls.enabled = true;
          domain_resolver = {
            server = "local";
            strategy = "prefer_ipv4";
          };
        }
        {
          type = "selector";
          tag = "select";
          outbounds = [
            "tyo0"
            "direct"
          ];
          default = "tyo0";
        }
        {
          type = "direct";
          tag = "direct";
          domain_resolver = {
            server = "local";
            strategy = "prefer_ipv4";
          };
        }
      ];

      route = {
        rules = [
          { action = "sniff"; }
          {
            rule_set = [
              "geoip-cn"
              "geosite-cn"
              "geosite-private"
            ];
            ip_is_private = true;
            outbound = "direct";
          }
        ];

        rule_set = [
          {
            tag = "geoip-cn";
            type = "local";
            format = "binary";
            path = "${pkgs.sing-geoip}/share/sing-box/rule-set/geoip-cn.srs";
          }
          {
            tag = "geosite-cn";
            type = "local";
            format = "binary";
            path = "${pkgs.sing-geosite}/share/sing-box/rule-set/geosite-cn.srs";
          }
          {
            tag = "geosite-private";
            type = "local";
            format = "binary";
            path = "${pkgs.sing-geosite}/share/sing-box/rule-set/geosite-private.srs";
          }
        ];

        default_domain_resolver = "local";
        final = "select";
      };
    };
  };

  ### System proxy settings
  networking.proxy = {
    httpProxy = "http://127.0.0.1:1080/";
    httpsProxy = "http://127.0.0.1:1080/";
  };

  programs.fish.shellAliases =
    let
      inherit (config.networking.proxy) httpProxy httpsProxy;
    in
    {
      "setproxy" = "export http_proxy=${httpProxy} https_proxy=${httpsProxy}";
      "unsetproxy" = "set -e http_proxy https_proxy";
    };

  ### sops-nix
  sops.secrets."sing-box/uuid" = {
    restartUnits = [ "sing-box.service" ];
    sopsFile = ./secrets.yaml;
  };
}
