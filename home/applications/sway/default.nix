{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ../common/wayland.nix
    ../common/wm.nix
    ../i3status-rust
    ../mako
    ../rofi
    ../swayidle
    ../swaylock
  ];

  services.cliphist.enable = true;
  services.udiskie.enable = true;

  home.sessionVariables = {
    # NOTE: don't use "wayland" in GTK_IM_MODULE! it will crash X11 electron apps
    GTK_IM_MODULE = lib.mkForce ""; # use text-input-v3
    QT_IM_MODULE = lib.mkForce ""; # use text-input-v3
  };

  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false; # wtf?
    extraOptions = ["--unsupported-gpu"];
    wrapperFeatures.gtk = true;
    systemd.xdgAutostart = true;
    config = {
      ### Startup
      startup = [
        {command = "systemctl --user import-environment PATH";}
      ];

      ### Visuals
      # https://danbooru.donmai.us/posts/6018861
      output."*".bg = "${./background.png} fill";
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
        screenshot = lib.getExe inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.scripts.screenshot;
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
          "${modifier}+Return" = "exec alacritty";
          "${modifier}+w" = "exec ${pkgs.xdg-utils}/bin/xdg-open http:";
          "${modifier}+e" = "exec ${pkgs.xdg-utils}/bin/xdg-open ~";

          # Rofi
          "${modifier}+d" = "exec rofi -show drun -show-icons -icon-theme ${config.gtk.iconTheme.name}";
          "${modifier}+Shift+d" = "exec ${lib.getExe pkgs.cliphist} list | rofi -dmenu | ${lib.getExe pkgs.cliphist} decode | ${pkgs.wl-clipboard}/bin/wl-copy";
          "${modifier}+Shift+Semicolon" = ''exec rofi -modi "power-menu:rofi-power-menu --confirm=reboot/shutdown" -show power-menu'';

          # Screenshot
          "${modifier}+Shift+s" = "exec ${screenshot} region";
          "Print" = "exec ${screenshot} fullscreen";
          "Print+Control" = "exec ${screenshot} swappy";

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
        builtins.listToAttrs (builtins.concatMap (x: [
          {
            name = "${modifier}+${x}";
            value = "workspace ${x}";
          }
          {
            name = "${modifier}+Shift+${x}";
            value = "move container to workspace ${x}";
          }
        ]) (builtins.genList (x: toString (x + 1)) 9));
    };
  };
}
