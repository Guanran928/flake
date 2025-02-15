{
  lib,
  pkgs,
  config,
  ...
}:
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

  home.sessionVariables = {
    ANDROID_USER_HOME = "${config.xdg.dataHome}/android";
    HISTFILE = "${config.xdg.stateHome}/bash_history";
  };

  home.packages = with pkgs; [
    fd
    jq
    libnotify
    loupe
    obs-studio
    pwvucontrol
    ripgrep
    seahorse
    telegram-desktop
    wl-clipboard
    yubikey-manager
  ];
}
