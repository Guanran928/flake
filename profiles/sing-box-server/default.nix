{ lib, config, ... }:
let
  inherit (config.networking) fqdn;
in
{
  sops.secrets."sing-box/auth" = {
    restartUnits = [ "sing-box.service" ];
    sopsFile = ./secrets.yaml;
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
            certificate_path = "/run/credentials/sing-box.service/cert";
            key_path = "/run/credentials/sing-box.service/key";
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

  systemd.services.sing-box.serviceConfig.LoadCredential =
    let
      # FIXME: remove somewhat hardcoded path
      path = "/var/lib/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory";
    in
    [
      "cert:${path}/${fqdn}/${fqdn}.crt"
      "key:${path}/${fqdn}/${fqdn}.key"
    ];
}
