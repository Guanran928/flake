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
      networkmanagerapplet
      pavucontrol

      # wayland
      wayland
      xdg-utils
      libnotify
      wl-clipboard
      cliphist
      swaylock-effects
      grim
      slurp
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

      # lsp
      nixd
      nil



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

      # game
      steam
      #lunar-client

      bitwarden
      #discord
      #qq
      tuba
      mousai
      protonup-qt
      piper
      prismlauncher
      telegram-desktop
      osu-lazer-bin
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
    sway = {
      enable = true;
      extraOptions = [ "--unsupported-gpu" "-D" "noscanout" ];
      wrapperFeatures.gtk = true;
      systemd = {
        enable = true;
        xdgAutostart = true;
      };
      config = {
        terminal = "${pkgs.alacritty}/bin/alacritty";
        bars = [ ];
        input = {
          "*" = {
            accel_profile = "flat";
            natural_scroll = "enabled";

            # touchpad
            tap = "enabled";
            drag = "enabled";
            dwt = "disabled";
          };
        };
        startup = [
          { command = "${pkgs.swww}/bin/swww init"; }
          { command = "${pkgs.waybar}/bin/waybar"; }
          { command = "${pkgs.wl-clipboard}/bin/wl-paste --watch cliphist store"; }
          #{ command = "${pkgs.alacritty}/bin/alacritty"; }
          #{ command = "${pkgs.fcitx5}/bin/fcitx5 -d"; }
          #{ command = "fcitx5 -d"; }
        ];
        gaps = {
          inner = 4;
          outer = 4;
          #smartGaps = true;
        };
        modifier = "Mod4";
        keybindings =
        let
          modifier        = config.wayland.windowManager.sway.config.modifier;
          setBrightness   = "/home/guanranwang/.local/bin/wrapped-brightnessctl";
          setVolume       = "/home/guanranwang/.local/bin/wrapped-pamixer";
          screenshot      = "/home/guanranwang/.local/bin/wrapped-grim";
          terminal        = "exec ${pkgs.alacritty}/bin/alacritty";
          browser         = "exec ${pkgs.xdg-utils}/bin/xdg-open http:";
          fileManager     = "exec ${pkgs.xdg-utils}/bin/xdg-open ~";
        in
        {
          ### Sway itself
          # Window
          "${modifier}+s"       = "split toggle";
          "${modifier}+v"       = "floating toggle";
          "${modifier}+f"       = "fullscreen";
          "${modifier}+q"       = "kill";
          "${modifier}+Shift+e" = "exec ${pkgs.sway}/bin/swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' '${pkgs.sway}/bin/swaymsg exit'";

          # Move around
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          # Workspaces
          # Switch to workspace
          "${modifier}+1" = "workspace 1";
          "${modifier}+2" = "workspace 2";
          "${modifier}+3" = "workspace 3";
          "${modifier}+4" = "workspace 4";
          "${modifier}+5" = "workspace 5";
          "${modifier}+6" = "workspace 6";
          "${modifier}+7" = "workspace 7";
          "${modifier}+8" = "workspace 8";
          "${modifier}+9" = "workspace 9";
          "${modifier}+0" = "workspace 10";
          # Move focused Window to workspace
          "${modifier}+Shift+1" = "move container to workspace 1";
          "${modifier}+Shift+2" = "move container to workspace 2";
          "${modifier}+Shift+3" = "move container to workspace 3";
          "${modifier}+Shift+4" = "move container to workspace 4";
          "${modifier}+Shift+5" = "move container to workspace 5";
          "${modifier}+Shift+6" = "move container to workspace 6";
          "${modifier}+Shift+7" = "move container to workspace 7";
          "${modifier}+Shift+8" = "move container to workspace 8";
          "${modifier}+Shift+9" = "move container to workspace 9";
          "${modifier}+Shift+0" = "move container to workspace 10";

          ### Execute other stuff
          # Launch applications
          "${modifier}+Return"    = terminal;
          "${modifier}+w"         = browser;
          "${modifier}+e"         = fileManager;

          # Rofi
          "${modifier}+d"         = "exec ${pkgs.rofi}/bin/rofi -show drun -show-icons -icon-theme ${config.gtk.iconTheme.name}";
          "${modifier}+Shift+d"   = "exec ${pkgs.cliphist}/bin/cliphist list | ${pkgs.rofi}/bin/rofi -dmenu | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy";
          "${modifier}+Shift+l"   = "exec ${pkgs.rofi}/bin/rofi -modi \"power-menu:rofi-power-menu --confirm=reboot/shutdown\" -show power-menu";

          # Screenshot
          "${modifier}+Shift+s"   = "exec ${screenshot} region";
          "Print"                 = "exec ${screenshot} fullscreen";

          # Fn keys
          "XF86MonBrightnessUp"   = "exec ${setBrightness} up";
          "XF86MonBrightnessDown" = "exec ${setBrightness} down";
          "XF86AudioRaiseVolume"  = "exec ${setVolume} up";
          "XF86AudioLowerVolume"  = "exec ${setVolume} down";
          "XF86AudioMute"         = "exec ${setVolume} mute";
          "XF86AudioPlay"         = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioPause"        = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioPrev"         = "exec ${pkgs.playerctl}/bin/playerctl previous";
          "XF86AudioNext"         = "exec ${pkgs.playerctl}/bin/playerctl next";
          "XF86AudioStop"         = "exec ${pkgs.playerctl}/bin/playerctl stop";
          "XF86AudioMedia"        = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        };
      };
      extraConfig = ''
        default_border pixel 2
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
    waybar = {
      enable = true;
      settings = {
        mainBar = {
          "layer" = "top";
          "modules-left" = [ "custom/launcher" "sway/workspaces" "gamemode" ];
          "modules-center" = [ "sway/window" ];
          "modules-right" = [ "tray" "pulseaudio" "battery" "clock" ];
          "custom/launcher" = { "format" = ""; };
          "gamemode" = {
            "format" = "{glyph} {count}";
            "glyph" = "󰊴";
            "hide-not-running" = true;
            "use-icon" = true;
            "icon-name" = "input-gaming-symbolic";
            "icon-spacing" = 4;
            "icon-size" = 20;
            "tooltip" = true;
            "tooltip-format" = "Games running = {count}";
          };
          "sway/workspaces" = {
            "format" = "{icon}";
            "format-icons" = {
              "1" = "";
              "2" = "";
              "3" = "";
              "4" = "";
              "5" = "";
              "urgent" = "";
              "active" = "";
              "default" = "";
            };
          };
          "sway/window" = {
            "format" = "{}";
            "separate-outputs" = true;
          };
          "tray" = {
            "spacing" = 10;
          };
          "pulseaudio" = {
            "format" = "{volume}% {icon}";
            "format-bluetooth" = "{volume}% {icon}";
            "format-muted" = "";
            "format-icons" = {
              "headphone" = "";
              "hands-free" = "󰂑";
              "headset" = "󰂑";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = [ "" "" ];
            };
            "scroll-step" = 5;
            "on-click" = "pavucontrol";
            "ignored-sinks" = ["Easy Effects Sink"];
          };
          "battery" = {
            "bat" = "BAT0";
            "interval" = 60;
            "states" = {
              "warning" = 30;
              "critical" = 15;
            };
            "format" = "{capacity}% {icon}";
            "format-icons" = [ "" "" "" "" "" ];
            "max-length" = 25;
          };
          "clock" = {
            "format" = "{:%A %H:%M} ";
            "tooltip-format" = "<tt>{calendar}</tt>";
          };
        };
      };
      style = ''
        * {
          font: bold 14px "JetBrainsMono Nerd Font Propo";
        }
        window#waybar {
          background: transparent;
        }
        tooltip {
          background: #1a1b26;
          color: #c0caf5;
          border: 2px solid #c0caf5;
          border-radius: 5px;
        }
        #custom-launcher,
        #gamemode,
        #window,
        #workspaces,
        #tray,
        #pulseaudio,
        #battery,
        #clock,
        #cava {
          text-shadow: 1px 1px 2px black;
          background: #1a1b26;
          color: #c0caf5; /* text color */
          margin: 10px 4px 4px 4px;
          padding: 4px 10px;
          box-shadow: 1px 1px 2px 1px rgba(0, 0, 0, 0.4);
          border-radius: 5px; /* rounded corners */
        }
        #custom-launcher {
          margin-left: 10px;
        }
        #clock {
          margin-right: 10px;
        }
        #workspaces {
          padding: 0px;
        }
        #workspaces button {
          text-shadow: 1px 1px 2px black;
          color: #c0caf5;
          padding: 0px 4px;
          border: 2px solid #1a1b26;
          transition-property: background, color, text-shadow, min-width;
          transition-duration: .15s;
        }
        #workspaces button.focused {
          text-shadow: none;
          color: #c0caf5;
          background: linear-gradient(
            70deg,
            rgb(192, 202, 245),
            rgb(192, 202, 245),
            rgb(192, 202, 245),
            rgb(192, 202, 245),
            rgb(229, 234, 255),
            rgb(192, 202, 245),
            rgb(192, 202, 245),
            rgb(192, 202, 245),
            rgb(192, 202, 245)
          );
          background-size: 300% 100%;
          background-position: 0% 0%;
          animation: colored-gradient 2s linear infinite;
          color: #1a1b26; /* icon(text) color */
          min-width: 36px;
        }
        #workspaces button.focused:hover {
          background: #9fa7cc; /* hovered workspace color */
        }
        #workspaces button:hover {
          background: #11111b; /* hovered workspace color */
        }
        @keyframes colored-gradient {
          from {background-position: 0% 0%;}
          to   {background-position: 100% 0%;}
        }
      '';
    };
    rofi = {
      #enable = true;
      package = pkgs.rofi-wayland;
      font = "monospace";
      terminal = "${pkgs.alacritty}/bin/alacritty";
    };

    mangohud = {
      enable = true;
      # TODO: add configuration, i have no idea how to display stuff with nix syntax
    };

    #boxxy = {
    #  enable = true;
    #  #rules = {
    #  #
    #  #};
    #};
  };
}
