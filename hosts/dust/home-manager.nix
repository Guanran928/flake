{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports =
    ../../home
    |> lib.fileset.fileFilter (file: file.hasExt "nix" && !lib.elem file.name [ "style.css.nix" ]) # FIXME: hack
    |> lib.fileset.toList;

  home = {
    stateVersion = "25.11";
    preferXdgDirectories = true;
  };

  home.sessionVariables = {
    # keep-sorted start
    ANDROID_USER_HOME = "${config.xdg.dataHome}/android";
    CARGO_HOME = "${config.xdg.cacheHome}/cargo";
    HISTFILE = "${config.xdg.stateHome}/bash_history";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MANROFFOPT = "-c";
    NH_FLAKE = "${config.home.homeDirectory}/Projects/flake";
    NIXOS_OZONE_WL = "1";
    PYTHON_HISTORY = "${config.xdg.stateHome}/python_history";
    # keep-sorted end
  };

  home.packages =
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    (with pkgs; [
      # keep-sorted start
      (osu-lazer-bin.override { nativeWayland = true; })
      android-tools
      bat
      brightnessctl
      deadnix
      eza
      fd
      gcc
      gh
      jq
      libnotify
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
      obsidian
      playerctl
      prismlauncher
      python3
      ripgrep
      sbctl
      sops
      statix
      telegram-desktop
      wl-clipboard
      # keep-sorted end
    ])
    ++ [
      inputs.kwin-effects-better-blur-dx.packages.${system}.default
      inputs.rdict.packages.${system}.default
    ];

  programs = {
    # keep-sorted start block=yes
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fzf = {
      enable = true;
      defaultOptions = [ "--color 16" ];
    };
    gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*.ny4.dev" = {
          user = "root";
        };
        "pek0.ny4.dev" = {
          hostname = "pek0"; # tailscale magicdns
        };
      };
    };
    tealdeer = {
      enable = true;
      settings = {
        display.use_pager = true;
        updates.auto_update = true;
      };
    };
    zoxide = {
      enable = true;
    };
    # keep-sorted end
  };

  services = {
    # keep-sorted start block=yes
    gpg-agent = {
      enable = pkgs.stdenv.hostPlatform.isLinux;
      pinentry.package = pkgs.pinentry-gnome3;
    };
    # keep-sorted end
  };

  xdg.configFile = {
    "go/env" = {
      text = ''
        GOPATH=${config.xdg.cacheHome}/go
        GOBIN=${config.xdg.stateHome}/go/bin
      '';
    };
    "nvim" = {
      source = ../../home/nvim;
      recursive = true;
    };
  };

  xdg.dataFile =
    [
      # keep-sorted start
      "foot-server"
      "footclient"
      "htop"
      "kbd-layout-viewer5"
      "nvim"
      "org.fcitx.fcitx5-migrator"
      # keep-sorted end
    ]
    |> map (x: {
      name = "applications/${x}.desktop";
      value.text = ''
        [Desktop Entry]
        Hidden=true
      '';
    })
    |> lib.listToAttrs;

  dconf.settings = {
    # keep-sorted start block=yes
    "org/gnome/desktop/interface" = {
      font-name = "Sans 11";
      document-font-name = "Sans 11";
      monospace-font-name = "Monospace 10";
      gtk-enable-primary-paste = false;
    };
    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Sans Bold 11";
    };
    "org/gnome/nautilus/list-view" = {
      default-zoom-level = "small";
    };
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
    };
    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = true;
    };
    # keep-sorted end
  };

  xdg = {
    enable = true;
  };

  xdg.terminal-exec = {
    enable = true;
    settings.default = [ "foot.desktop" ];
  };

  # Nautilus needs to read `~/.config/user-dirs.dirs` to determine folder icons
  xdg.userDirs = {
    enable = true;
    desktop = null;
    publicShare = null;
    templates = null;
  };

  fonts.fontconfig.enable = false;
}
