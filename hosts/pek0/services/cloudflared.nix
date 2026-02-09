{ config, lib, ... }:
{
  services.cloudflared = {
    enable = true;
    tunnels."36f02df3-b1f5-4447-be61-c1e5d4124ed1" = {
      credentialsFile = config.sops.secrets."cloudflared/secret".path;
      default = "http_status:404";
      ingress = lib.genAttrs [
        "pek0.ny4.dev"

        # keep-sorted start
        "cal.ny4.dev"
        "id.ny4.dev"
        "immich.ny4.dev"
        "mastodon.ny4.dev"
        "matrix.ny4.dev"
        "pb.ny4.dev"
        "rss.ny4.dev"
        "vault.ny4.dev"
        # keep-sorted end
      ] (_: "http://[::1]");
    };
  };

  systemd.services."cloudflared-tunnel-36f02df3-b1f5-4447-be61-c1e5d4124ed1" = {
    environment.TUNNEL_TRANSPORT_PROTOCOL = "http2"; # QUIC is quite unstable in Mainland China
  };

  sops.secrets."cloudflared/secret".restartUnits = [
    "cloudflared-tunnel-36f02df3-b1f5-4447-be61-c1e5d4124ed1.service"
  ];
}
