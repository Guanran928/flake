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
      ExecStart = "${pkgs.clash-meta}/bin/clash-meta -d /etc/clash-meta";
      Restart = "on-failure";
    };
  };

  environment.etc = {
    "clash-meta/config.yaml".source = config.sops.secrets."clash-config".path;
    "clash-meta/metacubexd" = {
      source = ../../flakes/home-manager/guanranwang/common/dotfiles/config/clash/metacubexd;
    };
  };
}