{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../dunst
    ../rofi
    ../swayidle
    ../swaylock
    ../udiskie
    ../waybar
  ];

  # https://wiki.archlinux.org/title/Fish#Start_X_at_login
  programs.fish.loginShellInit = ''
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
      exec sway
    end
  '';

  home.sessionVariables = {
    GTK_IM_MODULE = lib.mkForce "wayland"; # use text-input-v3
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
    extraOptions = ["--unsupported-gpu" "-D" "noscanout"];
    wrapperFeatures.gtk = true;
    systemd = {
      enable = true;
      xdgAutostart = true;
    };
    config = {
      ### Default Applications
      terminal = "${pkgs.alacritty}/bin/alacritty";
      menu = "${pkgs.rofi}/bin/rofi";

      ### Visuals
      bars = [];
      gaps = {
        inner = 4;
        outer = 4;
        #smartGaps = true;
      };
      output = {
        eDP-1 = {
          bg = "~/.local/share/backgrounds/wallpaper1.png fill";
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
      startup = [
        {command = "${pkgs.waybar}/bin/waybar";}
        {command = "${pkgs.wl-clipboard}/bin/wl-paste --watch cliphist store";}
      ];

      ### Keybinds
      modifier = "Mod4";
      modes = {};
      keybindings = let
        inherit (config.wayland.windowManager.sway.config) modifier;
        setBrightness = "/home/guanranwang/.local/bin/wrapped-brightnessctl";
        setVolume = "/home/guanranwang/.local/bin/wrapped-pamixer";
        screenshot = "/home/guanranwang/.local/bin/wrapped-grim";
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
        "${modifier}+Return" = "exec ${config.wayland.windowManager.sway.config.terminal}";
        "${modifier}+w" = "exec ${pkgs.xdg-utils}/bin/xdg-open http:";
        "${modifier}+e" = "exec ${pkgs.xdg-utils}/bin/xdg-open ~";

        # Rofi
        "${modifier}+d" = "exec ${config.wayland.windowManager.sway.config.menu} -show drun -show-icons -icon-theme ${config.gtk.iconTheme.name}";
        "${modifier}+Shift+d" = "exec ${pkgs.cliphist}/bin/cliphist list | ${config.wayland.windowManager.sway.config.menu} -dmenu | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy";
        "${modifier}+Shift+l" = "exec ${config.wayland.windowManager.sway.config.menu} -modi \"power-menu:rofi-power-menu --confirm=reboot/shutdown\" -show   power-menu";

        # Screenshot
        "${modifier}+Shift+s" = "exec ${screenshot} region";
        "${modifier}+Control+Shift+s" = "exec ${screenshot} region edit";
        "Print" = "exec ${screenshot} fullscreen";
        "Print+Control" = "exec ${screenshot} fullscreen edit";

        # Fn keys
        "XF86MonBrightnessUp" = "exec ${setBrightness} up";
        "XF86MonBrightnessDown" = "exec ${setBrightness} down";
        "XF86AudioRaiseVolume" = "exec ${setVolume} up";
        "XF86AudioLowerVolume" = "exec ${setVolume} down";
        "XF86AudioMute" = "exec ${setVolume} mute";
        "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
        "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
        "XF86AudioStop" = "exec ${pkgs.playerctl}/bin/playerctl stop";
        "XF86AudioMedia" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
      };
    };
  };
}
