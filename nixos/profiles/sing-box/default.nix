{
  pkgs,
  config,
  ...
}: {
  services.sing-box = {
    enable = true;
    settings = {
      log = {
        level = "info";
      };

      inbounds = [
        {
          type = "http";
          tag = "inbound";
          listen = "127.0.0.1";
          listen_port = 1080;
          sniff = true;
          sniff_override_destination = true;
        }
      ];

      outbounds = [
        {
          type = "hysteria2";
          tag = "tyo0";
          server = "tyo0.ny4.dev";
          server_port = 443;
          password._secret = config.sops.secrets."sing-box/tyo0".path;
          tls.enabled = true;
        }
        {
          type = "direct";
          tag = "direct";
        }
      ];

      route = {
        rules = [
          {
            rule_set = ["geoip-cn" "geosite-cn"];
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
        ];
        final = "tyo0";
      };

      experimental = {
        clash_api = {
          external_controller = "127.0.0.1:9090";
          external_ui = pkgs.metacubexd;
          secret = "hunter2";
        };
      };
    };
  };

  ### System proxy settings
  networking.proxy = {
    httpProxy = "http://127.0.0.1:1080/";
    httpsProxy = "http://127.0.0.1:1080/";
  };
  environment.shellAliases = let
    inherit (config.networking.proxy) httpProxy httpsProxy;
  in {
    "setproxy" = "export http_proxy=${httpProxy} https_proxy=${httpsProxy}";
    "unsetproxy" = "set -e http_proxy https_proxy";
  };

  ### sops-nix
  sops.secrets."sing-box/tyo0" = {
    restartUnits = ["sing-box.service"];
    sopsFile = ./secrets.yaml;
  };
}
