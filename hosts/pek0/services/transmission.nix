{ pkgs, ... }:
{
  services.transmission = {
    enable = true;
    openRPCPort = true;
    webHome = pkgs.flood-for-transmission;
    settings = {
      rpc-bind-address = "0.0.0.0";
      rpc-port = 9080;

      # tailscale
      rpc-whitelist = "100.*.*.*";
      rpc-host-whitelist = "blacksteel";

      incomplete-dir = "/mnt/torrent/downloading";
      download-dir = "/mnt/torrent";

      speed-limit-up-enabled = true;
      speed-limit-up = 2 * 1000;
      speed-limit-down-enabled = true;
      speed-limit-down = 32 * 1000;

      ratio-limit-enabled = true;
      ratio-limit = 2;
    };
  };
}
