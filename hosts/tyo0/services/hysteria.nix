{ config, ... }:
{
  services.hysteria = {
    enable = true;
    settings = {
      auth = {
        type = "userpass";
        userpass = {
          _secret = "/run/credentials/hysteria.service/auth";
          quote = false;
        };
      };
      masquerade = {
        type = "proxy";
        proxy.url = "https://ny4.dev/";
      };
      tls = {
        cert = "/run/credentials/hysteria.service/cert";
        key = "/run/credentials/hysteria.service/key";
      };
    };
  };

  systemd.services."hysteria".serviceConfig.LoadCredential = [
    # FIXME: remove hardcoded path
    "auth:${config.sops.secrets."hysteria/auth".path}"
    "cert:/var/lib/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/tyo0.ny4.dev/tyo0.ny4.dev.crt"
    "key:/var/lib/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/tyo0.ny4.dev/tyo0.ny4.dev.key"
  ];
}
