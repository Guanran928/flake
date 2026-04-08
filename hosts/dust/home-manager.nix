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
    MANPAGER = "bat -plman";
    NH_FLAKE = "${config.home.homeDirectory}/Projects/flake";
    PYTHON_HISTORY = "${config.xdg.stateHome}/python_history";
    # keep-sorted end
  };

  home.packages =
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    (with pkgs; [
      # keep-sorted start
      android-tools
      bat
      brightnessctl
      eza
      fd
      gcc
      gh
      jq
      libnotify
      numbat
      playerctl
      python3
      ripgrep
      sbctl
      sops
      wl-clipboard
      # keep-sorted end

      # keep-sorted start
      deadnix
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
      statix
      # keep-sorted end
    ])
    ++ [
      inputs.kwin-effects-better-blur-dx.packages.${system}.default
      inputs.rdict.packages.${system}.default
    ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      # NOTE: Append emoji font for Qt apps, they might use the monochrome emoji
      monospace = [
        "Iosevka"
        "Noto Sans"
        "Noto Sans CJK SC"
        "Symbols Nerd Font"
        "Noto Color Emoji"
      ];
      sansSerif = [
        "Inter"
        "Noto Sans"
        "Noto Sans CJK SC"
        "Noto Color Emoji"
      ];
      serif = [
        "Noto Serif"
        "Noto Serif CJK SC"
        "Noto Color Emoji"
      ];
    };
  };

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
      value.text = /* ini */ ''
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
    setSessionVariables = false;
    desktop = null;
    publicShare = null;
    templates = null;
  };
}
