{ pkgs, ... }:

# README!!:
# I HAVE NO IDEA HOW LAUNCHD DAEMON WORKS
# USE AT YOUR OWN RISK
# it just works™
#
# Remember to manually copy `config.yaml` to `/etc/clash-meta`
# I have no idea how to get sops-nix working on darwin...
#

{
  #environment.systemPackages = with pkgs; [ clash-meta ];
  # do i even need to add it to environment.systemPackages...
  launchd.daemons."clash-meta" = {
    command = "${pkgs.clash-meta}/bin/clash-meta -d /etc/clash-meta";
  };

  environment.variables = {
    "https_proxy" = "http://127.0.0.1:7890";
    "http_proxy" = "http://127.0.0.1:7890";
    "socks_proxy" = "socks5://127.0.0.1:7890";
    "all_proxy" = "socks5://127.0.0.1:7890";
  };

  environment.etc."clash-meta/metacubexd".source = ../../users/guanranwang/home-manager/common/dotfiles/config/clash/metacubexd;
}