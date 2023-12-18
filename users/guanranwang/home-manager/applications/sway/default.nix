{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../cliphist
    ../dunst
    ../rofi
    ../swayidle
    ../swaylock
    ../udiskie
    ../waybar
  ];

  home.sessionVariables = {
    GTK_IM_MODULE = lib.mkForce "wayland"; # use text-input-v3
    NIXOS_OZONE_WL = "1"; # let electron applications use wayland
  };

  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      "button-layout" = "icon,appmenu:"; # remove csd window buttons
    };
  };

  home.packages = with pkgs; [
    pamixer
    brightnessctl
    playerctl
    pavucontrol
    wl-clipboard
    cliphist
    grim
    slurp
    swappy
    #mpvpaper
    libnotify
    jq
  ];

  wayland.windowManager.sway = {
    enable = true;
    extraOptions = ["--unsupported-gpu" "-Dnoscanout"];
    wrapperFeatures.gtk = true;
    systemd.enable = true;
    systemd.xdgAutostart = true;
    config = {
      ### Default Applications
      terminal = lib.getExe pkgs.alacritty;
      menu = lib.getExe config.programs.rofi.package;

      ### Visuals
      #window.titlebar = false;
      bars = [
        {
          command = lib.getExe pkgs.waybar;
        }
        #{
        #  statusCommand = "${lib.getExe pkgs.i3status-rust} $HOME/.config/i3status-rust/config-default.toml";
        #  position = "top";
        #}
      ];
      gaps = {
        inner = 4;
        outer = 4;
        #smartGaps = true;
      };
      output = {
        eDP-1 = {
          bg = "~/.local/share/backgrounds/aqua.png fill";
        };
      };

      ### Inputs
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

      ### Autostarts
      startup = [];

      ### Keybinds
      modifier = "Mod4";
      modes = {};
      keybindings = let
        inherit (config.wayland.windowManager.sway.config) modifier;
        inherit (config.wayland.windowManager.sway.config) terminal;
        inherit (config.wayland.windowManager.sway.config) menu;
        setBrightness = "/home/guanranwang/.local/bin/wrapped-brightnessctl";
        setVolume = "/home/guanranwang/.local/bin/wrapped-pamixer";
        screenshot = "/home/guanranwang/.local/bin/screenshot";
      in {
        ### Sway itself
        # Window
        "${modifier}+s" = "split toggle";
        "${modifier}+v" = "floating toggle";
        "${modifier}+f" = "fullscreen";
        "${modifier}+q" = "kill";
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

        ### Execute other stuff
        # Launch applications
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+w" = "exec ${pkgs.xdg-utils}/bin/xdg-open http:";
        "${modifier}+e" = "exec ${pkgs.xdg-utils}/bin/xdg-open ~";

        # Rofi
        "${modifier}+d" = "exec ${menu} -show drun -show-icons -icon-theme ${config.gtk.iconTheme.name}";
        "${modifier}+Shift+d" = "exec ${lib.getExe pkgs.cliphist} list | ${menu} -dmenu | ${lib.getExe pkgs.cliphist} decode | ${pkgs.wl-clipboard}/bin/wl-copy";
        "${modifier}+Shift+l" = ''exec ${menu} -modi "power-menu:rofi-power-menu --confirm=reboot/shutdown" -show power-menu'';

        # Screenshot
        "${modifier}+Shift+s" = "exec ${screenshot} region";
        "Print" = "exec ${screenshot} fullscreen";
        "Print+Control" = "exec ${screenshot} swappy";

        # Fn keys
        "XF86MonBrightnessUp" = "exec ${setBrightness} up";
        "XF86MonBrightnessDown" = "exec ${setBrightness} down";
        "XF86AudioRaiseVolume" = "exec ${setVolume} up";
        "XF86AudioLowerVolume" = "exec ${setVolume} down";
        "XF86AudioMute" = "exec ${setVolume} mute";
        "XF86AudioPlay" = "exec ${lib.getExe pkgs.playerctl} play-pause";
        "XF86AudioPause" = "exec ${lib.getExe pkgs.playerctl} play-pause";
        "XF86AudioPrev" = "exec ${lib.getExe pkgs.playerctl} previous";
        "XF86AudioNext" = "exec ${lib.getExe pkgs.playerctl} next";
        "XF86AudioStop" = "exec ${lib.getExe pkgs.playerctl} stop";
        "XF86AudioMedia" = "exec ${lib.getExe pkgs.playerctl} play-pause";
      };
    };
  };
}
