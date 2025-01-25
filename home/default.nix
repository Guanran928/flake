{ lib, pkgs, ... }:
{
  home = {
    username = "guanranwang";
    homeDirectory = "/home/guanranwang";
    stateVersion = "24.05";
  };

  imports = [
    ./theme.nix
    ./xdg-mime.nix
  ] ++ lib.filter (x: lib.hasSuffix "default.nix" x) (lib.fileset.toList ./applications);

  programs = {
    fzf.enable = true;
    zoxide.enable = true;
  };

  services = {
    cliphist.enable = true;
  };

  home.packages = with pkgs; [
    dconf-editor
    fastfetch
    fd
    hyperfine
    jq
    libnotify
    loupe
    obs-studio
    pwvucontrol
    ripgrep
    seahorse
    telegram-desktop
    wl-clipboard
  ];
}
