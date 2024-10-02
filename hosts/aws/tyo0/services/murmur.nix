{ config, ... }:
let
  inherit (config.networking) fqdn;
in
{
  # `journalctl -u murmur.service | grep Password`
  services.murmur = {
    enable = true;
    openFirewall = true;
    bandwidth = 256 * 1024; # 256 Kbit/s
    sslCert = "/run/credentials/murmur.service/cert";
    sslKey = "/run/credentials/murmur.service/key";
  };

  systemd.services."murmur".serviceConfig.LoadCredential =
    let
      # FIXME: remove somewhat hardcoded path
      path = "/var/lib/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory";
    in
    [
      "cert:${path}/${fqdn}/${fqdn}.crt"
      "key:${path}/${fqdn}/${fqdn}.key"
    ];

}
