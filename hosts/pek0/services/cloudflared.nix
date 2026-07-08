{
  config,
  lib,
  data,
  ...
}:
{
  services.cloudflared = {
    enable = true;
    tunnels.${data.cloudflared.value.pek0} = {
      credentialsFile = config.sops.secrets."cloudflared/secret".path;
      default = "http_status:404";
      protocol = "http2"; # QUIC is quite unstable in Mainland China
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

  sops.secrets."cloudflared/secret".restartUnits = [
    "cloudflared-tunnel-${data.cloudflared.value.pek0}.service"
  ];
}
