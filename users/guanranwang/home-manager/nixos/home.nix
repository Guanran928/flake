{ config, pkgs, ... }:

{
  home = {
    username = "guanranwang";
    homeDirectory = "/home/guanranwang";

    # Environment variables
    sessionVariables = {
      # qt theme
      #"QT_STYLE_OVERRIDE"="kvantum";
    };

    packages = (with pkgs; [
      # x11 + wayland
      rofi-wayland
      rofi-power-menu
      dunst
      pamixer
      brightnessctl
      playerctl
      #networkmanagerapplet
      pavucontrol

      # wayland
      wl-clipboard
      cliphist
      swaylock-effects
      grim
      slurp
      swappy
      udiskie
      swww
      mpvpaper

      # x11
      #polybar
      #picom
      #feh
      #flameshot



      # gui
      gparted
      timeshift
      mpv
      spicetify-cli

      # TUI
      cava
      joshuto # rs
      bottom
      helix
      skim
      bat

      # cli
      fastfetch
      wget
      sops
      skim
      zoxide # rs
      trashy
      eza
      ripgrep
      fd
      freshfetch
      hyperfine

      # themes
      tela-icon-theme
      tela-circle-icon-theme
      papirus-icon-theme
      adw-gtk3
      libsForQt5.qtstyleplugin-kvantum # Kvantum, theme engine


      ### flatpak-able

      # browser
      #brave
      #google-chrome
      #firefox
      librewolf
      #microsoft-edge

      # matrix
      #fluffychat
      element-desktop
      cinny-desktop
      #nheko

      # music
      easyeffects
      spotify
      yesplaymusic
      amberol
      netease-cloud-music-gtk

      bitwarden
      #discord
      #qq
      tuba
      mousai
      protonup-qt
      piper
      telegram-desktop
      qbittorrent
      gradience
      dippi
      obs-studio
      gnome.seahorse
      gnome.eog
      gnome.file-roller
      gnome.gnome-weather
      gnome.gnome-calculator
      gnome.dconf-editor
    ]) ++ (with pkgs.gnome; [
      # GNOME
      nautilus
      zenity

      # GNOME only
      #gnome-tweaks
      #gnome-software
      #gnome-shell-extensions
    ]) ++ (with pkgs.gnomeExtensions; [
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
    ]) ++ (with pkgs.fishPlugins; [
      autopair
      done
      #tide
      sponge
      puffer
    ]);

    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
      size = 24;
    };
  };

  gtk = {
    enable = true;
    font.name = "Sans";
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
      size = 24;
    };
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      #name = "Tela-dracula-dark";
      #package = pkgs.tela-icon-theme;
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
  };

  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      "titlebar-font" = "Sans Bold";
      "button-layout" = "icon,appmenu:";
    };
    "org/gnome/desktop/interface" = {
      "clock-format" = "12h";
      "color-scheme" = "prefer-dark";
      "document-font-name" = "Sans";
      "font-name" = "Sans";
      "monospace-font-name" = "Monospace";
    };
  };

  fonts.fontconfig.enable = true;

  # X resources file
  # ~/.Xresources
  xresources.properties = {
    # Cursor
    "Xcursor.theme" = "Adwaita";

    # Fonts
    "Xft.autohint" = "0";
    "Xft.lcdfilter" = "lcddefault";
    "Xft.hintstyle" = "hintslight";
    "Xft.hinting" = "1";
    "Xft.antialias" = "1";
    "Xft.rgba" = "rgb";

    # Tokyonight color scheme
    # i have no idea what does it apply to
    "*background" = "#1a1b26";
    "*foreground" = "#c0caf5";

    "*color0" = "#15161e";
    "*color1" = "#f7768e";
    "*color2" = "#9ece6a";
    "*color3" = "#e0af68";
    "*color4" = "#7aa2f7";
    "*color5" = "#bb9af7";
    "*color6" = "#7dcfff";
    "*color7" = "#a9b1d6";

    "*color8" = "#414868";
    "*color9" = "#f7768e";
    "*color10" = "#9ece6a";
    "*color11" = "#e0af68";
    "*color12" = "#7aa2f7";
    "*color13" = "#bb9af7";
    "*color14" = "#7dcfff";
    "*color15" = "#c0caf5";
  };

  wayland.windowManager = {
    hyprland = {
      enable = true;
      enableNvidiaPatches = true;
      xwayland = {
        enable = true;
      };
      extraConfig = ''
        #source = ~/.config/hypr/themes/mocha.conf
        #source = ~/.config/hypr/themes/colors.conf
        #source = ~/.config/hypr/plugins.conf
        source = ~/.config/hypr/main.conf
        source = ~/.config/hypr/keybinds.conf
        source = ~/.config/hypr/autostart.conf
        source = ~/.config/hypr/env.conf
      '';
    };
  };

  #xsession = {
  #  enable = true;
  #  windowManager.bspwm = {
  #    enable = true;
  #  };
  #};

  programs = {
    fish.loginShellInit = ''
      if status is-login
        if test -z "$Display" -a "$XDG_VTNR" = 1
          exec sway
        end
      end
    '';
    rofi = {
      #enable = true;
      package = pkgs.rofi-wayland;
      font = "monospace";
      terminal = "${pkgs.alacritty}/bin/alacritty";
    };

    #boxxy = {
    #  enable = true;
    #  #rules = {
    #  #
    #  #};
    #};
  };
}
