{ pkgs, config, ... }:

{
  networking = {
    proxy = {
      default = "http://127.0.0.1:7890/";
      noProxy = "127.0.0.1,localhost";
    };
  };

  environment.systemPackages = with pkgs; [ clash-meta ];
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

  environment.etc."clash-meta/metacubexd".source = ../../users/guanranwang/home-manager/common/dotfiles/config/clash/metacubexd;
}