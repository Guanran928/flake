{ lib, config, ... }:
{
  networking.firewall.allowedTCPPorts = [
    27253
  ];

  services.sing-box = {
    enable = true;
    settings = {
      log = {
        level = "info";
      };

      inbounds = [
        {
          type = "vless";
          tag = "inbound";
          listen = "0.0.0.0";
          listen_port = 27253;
          users = {
            _secret = config.sops.secrets."sing-box/auth".path;
            quote = false;
          };
          tls = {
            enabled = true;
            server_name = "tyo0.ny4.dev";
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

  systemd.services."sing-box".serviceConfig.LoadCredential =
    let
      # FIXME: remove hardcoded path
      path = "/var/lib/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/tyo0.ny4.dev";
    in
    [
      "cert:${path}/tyo0.ny4.dev.crt"
      "key:${path}/tyo0.ny4.dev.key"
    ];
}
