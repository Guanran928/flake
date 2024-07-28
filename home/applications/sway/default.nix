{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../i3status-rust
    ../kanshi
    ../mako
    ../swayidle
    ../swaylock

    # FIXME: hack
    ./unset-im-module.nix
  ];

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # let electron applications use wayland
  };

  home.packages = with pkgs; [
    wl-clipboard
    pwvucontrol
  ];

  # remove csd window buttons
  # https://github.com/localsend/localsend/blob/2457acd8a7412723b174672d174e4853dccd7d99/app/linux/my_application.cc#L45
  home.sessionVariables.GTK_CSD = 0;
  dconf.settings."org/gnome/desktop/wm/preferences"."button-layout" = "appmenu:";

  services.cliphist.enable = true;
  services.udiskie.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false; # wtf?
    wrapperFeatures.gtk = true;
    systemd.xdgAutostart = true;
    config = {
      ### Startup
      startup = [
        {command = "systemctl --user import-environment PATH";}
      ];

      ### Visuals
      output."*".bg = "${inputs.self.legacyPackages.${pkgs.stdenv.hostPlatform.system}.background} fill";
      bars = [
        {
          statusCommand = "${lib.getExe pkgs.i3status-rust} $HOME/.config/i3status-rust/config-default.toml";
          position = "top";
          extraConfig = ''
            icon_theme ${config.gtk.iconTheme.name}
          '';
        }
      ];

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
          xkb_options = "caps:escape";
          xkb_variant = "dvorak";
        };
      };

      ### Keybinds
      modifier = "Mod4";
      keybindings = let
        inherit (config.wayland.windowManager.sway.config) modifier;
      in
        {
          ### Sway itself
          # Window
          "${modifier}+s" = "split toggle";
          "${modifier}+v" = "floating toggle";
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+r" = "mode resize";
          "${modifier}+q" = "kill";
          "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

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
          "${modifier}+Return" = "exec ${lib.getExe pkgs.foot}";
          "${modifier}+w" = "exec ${pkgs.xdg-utils}/bin/xdg-open http:";
          "${modifier}+e" = "exec ${pkgs.xdg-utils}/bin/xdg-open ~";

          # Launcher
          "${modifier}+d" = "exec ${lib.getExe' pkgs.wmenu "wmenu-run"}";
          "${modifier}+Shift+d" = "exec ${lib.getExe pkgs.cliphist} list | ${lib.getExe pkgs.wmenu} -l 10 | ${lib.getExe pkgs.cliphist} decode | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}";
          "${modifier}+Shift+Semicolon" = "exec loginctl lock-session";

          # Screenshot
          "Print" = "exec env XDG_SCREENSHOTS_DIR=$HOME/Pictures/Screenshots ${lib.getExe pkgs.sway-contrib.grimshot} --notify savecopy anything";

          # Fn keys
          "XF86MonBrightnessUp" = "exec ${lib.getExe pkgs.brightnessctl} set 5%+";
          "XF86MonBrightnessDown" = "exec ${lib.getExe pkgs.brightnessctl} set 5%-";
          "XF86AudioRaiseVolume" = "exec ${lib.getExe pkgs.pamixer} -i5";
          "XF86AudioLowerVolume" = "exec ${lib.getExe pkgs.pamixer} -d5";
          "XF86AudioMute" = "exec ${lib.getExe pkgs.pamixer} -t";
          "XF86AudioPlay" = "exec ${lib.getExe pkgs.playerctl} play-pause";
          "XF86AudioPrev" = "exec ${lib.getExe pkgs.playerctl} previous";
          "XF86AudioNext" = "exec ${lib.getExe pkgs.playerctl} next";
          "XF86AudioStop" = "exec ${lib.getExe pkgs.playerctl} stop";
        }
        //
        # workspace binds
        lib.listToAttrs (lib.concatMap (x: [
          {
            name = "${modifier}+${x}";
            value = "workspace ${x}";
          }
          {
            name = "${modifier}+Shift+${x}";
            value = "move container to workspace ${x}";
          }
        ]) (lib.genList (x: toString (x + 1)) 9));
    };
  };
}
