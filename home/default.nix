{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./theme.nix
    ./xdg-mime.nix
  ]
  ++ lib.filter (x: lib.hasSuffix ".nix" x) (lib.fileset.toList ./applications);

  home = {
    username = "guanranwang";
    homeDirectory = "/home/guanranwang";
    stateVersion = "25.05";
  };

  home.sessionVariables = {
    ANDROID_USER_HOME = "${config.xdg.dataHome}/android";
    CARGO_HOME = "${config.xdg.cacheHome}/cargo";
    GTK_CSD = 0;
    HISTFILE = "${config.xdg.stateHome}/bash_history";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MANROFFOPT = "-c";
    NH_FLAKE = "/home/guanranwang/Projects/flake";
    PYTHON_HISTORY = "${config.xdg.stateHome}/python_history";
    QT_QPA_PLATFORMTHEME = "gtk3";
  };

  home.packages =
    (with pkgs; [
      bat
      brightnessctl
      deadnix
      eza
      fd
      gcc
      jq
      libnotify
      loupe
      nh
      nil
      nix-diff
      nix-index
      nix-init
      nix-output-monitor
      nix-tree
      nix-update
      nixfmt
      nixpkgs-review
      numbat
      obs-studio
      playerctl
      pwvucontrol
      python3
      ripgrep
      seahorse
      sops
      statix
      telegram-desktop
      wl-clipboard
    ])
    ++ [ inputs.rdict.packages.${pkgs.stdenv.hostPlatform.system}.default ];

  programs = {
    zoxide.enable = true;
    gh.enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    defaultOptions = [ "--color 16" ];
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*.ny4.dev" = {
        identityFile = "${config.home.homeDirectory}/.ssh/id_github_signing";
        user = "root";
      };
      "pek0.ny4.dev".hostname = "blacksteel";
    };
  };

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };

  programs.tealdeer = {
    enable = true;
    settings = {
      display.use_pager = true;
      updates.auto_update = true;
    };
  };

  services.cliphist = {
    enable = true;
    extraOptions = [
      "-max-items"
      "100"
    ];
  };

  services.gpg-agent = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    pinentry.package = pkgs.pinentry-gnome3;
  };

  services.mako = {
    enable = true;
    settings = {
      default-timeout = "5000";
      layer = "overlay";
    };
  };

  xdg.configFile."go/env".text = ''
    GOPATH=${config.xdg.cacheHome}/go
    GOBIN=${config.xdg.stateHome}/go/bin
  '';

  xdg.configFile."nvim" = {
    source = ./applications/nvim;
    recursive = true;
  };
}
