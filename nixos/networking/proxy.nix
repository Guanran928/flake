{ pkgs, config, inputs, ... }:

{
  networking.proxy.default = "http://127.0.0.1:7890/";

  #environment.systemPackages = with pkgs; [ clash-meta ];
  systemd.services."clash-meta" = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    description = "Clash.Meta Daemon";
    serviceConfig = {
      Type = "simple";
      WorkingDirectory = "/etc/clash-meta";
      User = [ config.users.users."clash-meta".name ];
      ExecStart = "${pkgs.clash-meta}/bin/clash-meta -d /etc/clash-meta";
      Restart = "on-failure";
      CapabilityBoundingSet = [
        "CAP_NET_RAW"
        "CAP_NET_ADMIN"
        "CAP_NET_BIND_SERVICE"
      ];
      AmbientCapabilities = [
        "CAP_NET_RAW"
        "CAP_NET_ADMIN"
        "CAP_NET_BIND_SERVICE"
      ];
    };
  };

  ### Local Clash WebUI
  # You can also use the following website, just in case:
  # - metacubexd:
  #   - GH Pages Custom Domain: http://d.metacubex.one
  #   - GH Pages: https://metacubex.github.io/metacubexd
  #   - Cloudflare Pages: https://metacubexd.pages.dev
  # - yacd (Yet Another Clash Dashboard):
  #   - https://yacd.haishan.me
  # - clash-dashboard (buggy):
  #   - https://clash.razord.top
  environment.etc."clash-meta/metacubexd".source = inputs.metacubexd;
}