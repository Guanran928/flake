{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = ../../home |> lib.fileset.fileFilter (file: file.hasExt "nix") |> lib.fileset.toList;

  home = {
    stateVersion = "25.11";
  };

  home.sessionVariables = {
    # keep-sorted start
    ANDROID_USER_HOME = "${config.xdg.dataHome}/android";
    CARGO_HOME = "${config.xdg.cacheHome}/cargo";
    GTK_CSD = 0;
    HISTFILE = "${config.xdg.stateHome}/bash_history";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MANROFFOPT = "-c";
    NH_FLAKE = "${config.home.homeDirectory}/Projects/flake";
    PYTHON_HISTORY = "${config.xdg.stateHome}/python_history";
    # keep-sorted end
  };

  home.packages =
    (with pkgs; [
      # keep-sorted start
      (osu-lazer-bin.override { nativeWayland = true; })
      bat
      brightnessctl
      deadnix
      eza
      fd
      gcc
      gh
      jq
      libnotify
      loupe
      nautilus
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
      prismlauncher
      pwvucontrol
      python3
      ripgrep
      sbctl
      seahorse
      sops
      statix
      telegram-desktop
      wl-clipboard
      xwayland-satellite
      # keep-sorted end
    ])
    ++ [ inputs.rdict.packages.${pkgs.stdenv.hostPlatform.system}.default ];

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
          hostname = "blacksteel";
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
    cliphist = {
      enable = true;
      extraOptions = [
        "-max-items"
        "100"
      ];
    };
    gpg-agent = {
      enable = pkgs.stdenv.hostPlatform.isLinux;
      pinentry.package = pkgs.pinentry-gnome3;
    };
    mako = {
      enable = true;
      settings = {
        default-timeout = "5000";
        layer = "overlay";
      };
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
    "niri" = {
      source = ../../home/niri;
    };
    "mimeapps.list" = {
      force = true;
    };
  };

  xdg.dataFile = {
    "applications/mimeapps.list" = {
      enable = false;
    };
  }
  // (
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
    |> lib.listToAttrs
  );

  systemd.user.services.swaybg = {
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Unit = {
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.swaybg} -i ${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src} -m fill";
      Restart = "on-failure";
    };
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    dotIcons.enable = false;
    gtk.enable = true;
  };

  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    gtk4.theme = null;

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  dconf.settings = {
    # keep-sorted start block=yes
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/interface" = {
      font-name = "Sans 11";
      document-font-name = "Sans 11";
      monospace-font-name = "Monospace 10";
    };
    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Sans Bold 11";
      button-layout = "appmenu:";
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

  # https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
  xdg.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      {
        # keep-sorted start block=yes
        "mpv.desktop" = [
          "audio/aac"
          "audio/flac"
          "audio/mpeg"
          "audio/ogg"
          "audio/wav"
          "video/mp4"
          "video/mpeg"
          "video/webm"
        ];
        "nvim.desktop" = [
          "text/css"
          "text/javascript"
          "text/plain"
        ];
        "org.gnome.Loupe.desktop" = [
          "image/gif"
          "image/jpeg"
          "image/png"
          "image/webp"
        ];
        "thunderbird.desktop" = [
          "x-scheme-handler/mailto"
          "x-scheme-handler/mid"
        ];
        "zen-twilight.desktop" = [
          "text/html"
          "x-scheme-handler/about"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "x-scheme-handler/unknown"
        ];
        # keep-sorted end
      }
      |> lib.mapAttrsToList lib.nameValuePair
      |> map (x: lib.genAttrs x.value (_: x.name))
      |> lib.mkMerge;
  };
}
