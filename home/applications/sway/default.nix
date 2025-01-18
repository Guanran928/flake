{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  # remove csd window buttons
  # https://github.com/localsend/localsend/blob/2457acd8a7412723b174672d174e4853dccd7d99/app/linux/my_application.cc#L45
  home.sessionVariables.GTK_CSD = 0;
  dconf.settings."org/gnome/desktop/wm/preferences"."button-layout" = "appmenu:";

  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false; # wtf?
    wrapperFeatures.gtk = true;
    systemd.xdgAutostart = true;
    config = {
      ### Visuals
      output."*".bg = "${inputs.self.legacyPackages.${pkgs.stdenv.hostPlatform.system}.background} fill";
      bars = lib.singleton {
        statusCommand = "${lib.getExe pkgs.i3status-rust} $HOME/.config/i3status-rust/config-default.toml";
        position = "top";
        extraConfig = ''
          icon_theme ${config.gtk.iconTheme.name}
        '';
      };

      ### Inputs
      input = {
        "*" = {
          accel_profile = "flat";
          natural_scroll = "enabled";
        };

        "type:touchpad" = {
          tap = "enabled";
          drag = "enabled";
          dwt = "disabled";
        };

        "type:keyboard" = {
          xkb_layout = "us";
          xkb_options = "caps:escape,altwin:swap_lalt_lwin";
          xkb_variant = "dvorak";
        };
      };

      ### Keybinds
      modifier = "Mod4";
      keybindings =
        let
          inherit (config.wayland.windowManager.sway.config) modifier;
          inherit (lib) getExe getExe';
          inherit (config.programs) firefox foot;
          inherit (pkgs)
            brightnessctl
            cliphist
            pamixer
            playerctl
            sway-contrib
            wireplumber
            wl-clipboard
            fuzzel
            ;
        in
        {
          ### Sway itself
          # Window
          "${modifier}+s" = "split toggle";
          "${modifier}+v" = "floating toggle";
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+r" = "mode resize";
          "${modifier}+q" = "kill";
          "${modifier}+Shift+e" =
            "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

          # Move around
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";
          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          ### Execute other stuff
          # Launch applications
          "${modifier}+Return" = "exec ${getExe foot.package}";
          "${modifier}+w" = "exec ${getExe firefox.finalPackage}";

          # Launcher
          "${modifier}+d" = "exec ${getExe fuzzel}";
          "${modifier}+Shift+d" =
            "exec ${getExe cliphist} list | ${getExe fuzzel} -d | ${getExe cliphist} decode | ${getExe' wl-clipboard "wl-copy"}";
          "${modifier}+Shift+Semicolon" = "exec loginctl lock-session";

          # Screenshot
          "Print" =
            "exec env XDG_SCREENSHOTS_DIR=$HOME/Pictures/Screenshots ${getExe sway-contrib.grimshot} --notify savecopy anything";

          # Fn keys
          "XF86MonBrightnessUp" = "exec ${getExe brightnessctl} set 5%+";
          "XF86MonBrightnessDown" = "exec ${getExe brightnessctl} set 5%-";
          "XF86AudioRaiseVolume" = "exec ${getExe' wireplumber "wpctl"} set-volume @DEFAULT_SINK@ 5%+";
          "XF86AudioLowerVolume" = "exec ${getExe' wireplumber "wpctl"} set-volume @DEFAULT_SINK@ 5%-";
          "XF86AudioMute" = "exec ${getExe pamixer} -t";
          "XF86AudioPlay" = "exec ${getExe playerctl} play-pause";
          "XF86AudioPrev" = "exec ${getExe playerctl} previous";
          "XF86AudioNext" = "exec ${getExe playerctl} next";
          "XF86AudioStop" = "exec ${getExe playerctl} stop";
        }
        //
          # workspace binds
          lib.listToAttrs (
            lib.concatMap (x: [
              {
                name = "${modifier}+${x}";
                value = "workspace ${x}";
              }
              {
                name = "${modifier}+Shift+${x}";
                value = "move container to workspace ${x}";
              }
            ]) (lib.genList (x: toString (x + 1)) 9)
          );
    };
  };
}
