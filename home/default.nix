{
  lib,
  config,
  inputs,
  pkgs,
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
  ]
  ++ lib.filter (x: lib.hasSuffix "default.nix" x) (lib.fileset.toList ./applications);

  programs = {
    zoxide.enable = true;
  };

  home.sessionVariables = {
    ANDROID_USER_HOME = "${config.xdg.dataHome}/android";
    CARGO_HOME = "${config.xdg.cacheHome}/cargo";
    HISTFILE = "${config.xdg.stateHome}/bash_history";
  };

  home.packages =
    (with pkgs; [
      fd
      jq
      libnotify
      loupe
      numbat
      obs-studio
      pwvucontrol
      ripgrep
      seahorse
      telegram-desktop
      wl-clipboard
      yubikey-manager
    ])
    ++ [ inputs.rdict.packages.${pkgs.stdenv.hostPlatform.system}.default ];
}
