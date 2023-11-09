# why is this placed in ./wm
{pkgs, ...}: {
  imports = [
    ./components/wallpaper.nix
  ];
  home.packages = with pkgs.gnomeExtensions; [
    # GNOME extensions
    arcmenu
    appindicator
    blur-my-shell
    caffeine
    dash-to-panel
    dash-to-dock
    gamemode # outdated
    just-perfection
    kimpanel
  ];
}
