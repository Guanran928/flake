{ lib, config, ... }:
let
  inherit (config.networking) fqdn;
in
{
  sops.secrets = {
    "sing-box/auth" = {
      restartUnits = [ "sing-box.service" ];
      sopsFile = ./secrets.yaml;
    };
    "sing-box/dns01_token" = {
      restartUnits = [ "sing-box.service" ];
      sopsFile = ./secrets.yaml;
    };
  };

  services.sing-box = {
    enable = true;
    settings = {
      log = {
        level = "warn";
      };

      inbounds = [
        {
          type = "vless";
          tag = "inbound";
          listen = "::";
          listen_port = 27253;
          users = {
            _secret = config.sops.secrets."sing-box/auth".path;
            quote = false;
          };
          tls = {
            enabled = true;
            server_name = fqdn;
            acme = {
              domain = [ fqdn ];
              dns01_challenge = {
                provider = "cloudflare";
                api_token._secret = config.sops.secrets."sing-box/dns01_token".path;
              };
            };
          };
        }
      ];

      outbounds = lib.singleton {
        type = "direct";
        tag = "direct";
      };

      route = {
        final = "direct";
      };
    };
  };
}
