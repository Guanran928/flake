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
    stateVersion = "25.05";
  };

  home.sessionVariables = {
    ANDROID_USER_HOME = "${config.xdg.dataHome}/android";
    CARGO_HOME = "${config.xdg.cacheHome}/cargo";
    GTK_CSD = 0;
    HISTFILE = "${config.xdg.stateHome}/bash_history";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MANROFFOPT = "-c";
    NH_FLAKE = "${config.home.homeDirectory}/Projects/flake";
    PYTHON_HISTORY = "${config.xdg.stateHome}/python_history";
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
    source = ../../home/nvim;
    recursive = true;
  };

  xdg.configFile."niri" = {
    source = ../../home/niri;
  };

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
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Sans Bold 11";
      button-layout = "appmenu:";
    };
    "org/gnome/desktop/interface" = {
      font-name = "Sans 11";
      document-font-name = "Sans 11";
      monospace-font-name = "Monospace 10";
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
  };

  # https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
  xdg.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      ### Browser
      lib.genAttrs [
        "text/html"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/about"
        "x-scheme-handler/unknown"
      ] (_n: [ "zen-twilight.desktop" ])
      ### Audio player
      // lib.genAttrs [ "audio/aac" "audio/flac" "audio/mpeg" "audio/ogg" "audio/wav" ] (_n: [
        "mpv.desktop"
      ])
      ### Image viewer
      // lib.genAttrs [ "image/gif" "image/jpeg" "image/png" "image/webp" ] (_n: [
        "org.gnome.Loupe.desktop"
      ])
      ### Video player
      // lib.genAttrs [ "video/mp4" "video/mpeg" "video/webm" ] (_n: [ "mpv.desktop" ])
      ### Code editor
      // lib.genAttrs [ "text/css" "text/javascript" "text/plain" ] (_n: [ "nvim.desktop" ])
      ### Mail client
      // lib.genAttrs [ "x-scheme-handler/mailto" "x-scheme-handler/mid" ] (_n: [
        "thunderbird.desktop"
      ]);
  };

  xdg.dataFile."applications/mimeapps.list".enable = false;
  xdg.configFile."mimeapps.list".force = true;
}
