{ config, lib, ... }:
{
  services.cloudflared = {
    enable = true;
    tunnels."56cb139d-be03-46a9-b5ef-d00af5f8ef33" = {
      credentialsFile = config.sops.secrets."cloudflared/secret".path;
      default = "http_status:404";
      ingress = lib.genAttrs [ "mastodon.ny4.dev" "matrix.ny4.dev" "pek0.ny4.dev" ] (
        _: "http://localhost"
      );
    };
  };

  sops.secrets."cloudflared/secret".restartUnits = [
    "cloudflared-tunnel-56cb139d-be03-46a9-b5ef-d00af5f8ef33.service"
  ];
}
