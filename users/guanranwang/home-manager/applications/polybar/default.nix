_: {
  services.polybar = {
    enable = true;
    script = "polybar bar";
    config = {
      colors = {
        base = "#1e1e2e";
        mantle = "#181825";
        crust = "#cc11111b";

        text = "#cdd6f4";
        subtext0 = "#a6adc8";
        subtext1 = "#bac2de";

        surface0 = "#313244";
        surface1 = "#45475a";
        surface2 = "#585b70";

        overlay0 = "#6c7086";
        overlay1 = "#7f849c";
        overlay2 = "#9399b2";

        blue = "#89b4fa";
        lavender = "#b4befe";
        sapphire = "#74c7ec";
        sky = "#89dceb";
        teal = "#94e2d5";
        green = "#a6e3a1";
        yellow = "#f9e2af";
        peach = "#fab387";
        maroon = "#eba0ac";
        red = "#f38ba8";
        mauve = "#cba6f7";
        pink = "#f5c2e7";
        flamingo = "#f2cdcd";
        rosewater = "#f5e0dc";

        transparent = "#FF00";
      };

      "bar/main" = {
        width = "100%";
        height = 30;
        offset-y = 0;
        top = true;
        fixed-center = true;

        wm-restack = "bspwm";
        override-redirect = false;

        scroll-up = "next";
        scroll-down = "prev";

        enable-ipc = true;

        background = "\${colors.crust}";
        foreground = "\${colors.text}";

        font-0 = "JetBrainsMono Nerd Font:style=Bold:size=10;2";
        font-1 = "Source Han Sans CN:size=10;2";

        modules-left = "bspwm";
        modules-center = "title";
        modules-right = "pulseaudio battery date";

        tray-position = "right";

        cursor-click = "pointer";
      };

      settings = {
        screenchange-reload = true;
        format-padding = 1;
      };

      "module/nowplaying" = {
        type = "custom/script";
        tail = true;
        interval = 1;
        format = "󰕾 <label>";
        exec = "playerctl metadata --format \"{{ artist }} - {{ title }}\"";
      };

      "module/battery" = {
        type = "internal/battery";
        battery = "BAT0";
        adapter = "ADP1";
        full-at = 98;
        low-at = 30;
        format-full-prefix = "󰁹";
        format-full = "<label-charging>";
        format-charging-prefix = "󰂄";
        format-charging = "<label-charging>";
        label-charging = "%percentage:2%%";
        label-charging-padding = 1;
        format-discharging = "<ramp-capacity> <label-discharging>";
        label-discharging = "%percentage%%";
        label-discharging-padding = 1;
        ramp-capacity-0 = "󰁺";
        ramp-capacity-1 = "󰁼";
        ramp-capacity-2 = "󰁾";
        ramp-capacity-3 = "󰁾";
        ramp-capacity-4 = "󰂂";
        ramp-capacity-5 = "󰁹";
        ramp-capacity-5-weight = 2;
        format-low = "<ramp-capacity> <label-low>";
        label-low-padding = 1;
        label-low-foreground = "\${colors.red}";
        poll-interval = 5;
      };

      "module/bspwm" = {
        type = "internal/bspwm";

        format = "<label-state> <label-mode>";

        label-focused = "%name%";
        label-focused-foreground = "\${colors.text}";
        label-focused-padding = 1;

        label-occupied = "%name%";
        label-occupied-foreground = "\${colors.overlay0}";
        label-occupied-padding = 1;

        label-urgent = "%name%";
        label-urgent-foreground = "\${colors.red}";
        label-urgent-padding = 1;

        label-empty = "%name%";
        label-empty-foreground = "\${colors.surface0}";
        label-empty-padding = 1;
      };

      "module/date" = {
        type = "internal/date";
        interval = 1;

        time = "%a, %b %d %H:%M";

        format = "<label>";
        format-padding = 1;
        format-prefix = "%{T5}󰃭%{T-}";
        label = "%{T1}%time%%{T-}";
        label-padding = 1;
      };

      "module/pulseaudio" = {
        type = "internal/pulseaudio";
        use-ui-max = false;

        format-volume = "<label-volume>";
        format-volume-prefix = "%{T4}󰖁%{T-}";
        label-volume = "%{T1}%percentage%%%{T-}";
        label-volume-padding = 1;

        format-muted = "<label-muted>";
        format-muted-prefix = "󰸈";
        label-muted = "%{T1}%percentage%%%{T-}";
        label-muted-padding = 1;

        click-right = "pavucontrol&";
      };

      "module/title" = {
        type = "internal/xwindow";
        format = "<label>";
        format-padding = 4;

        label = "%title%";
        label-maxlen = 50;

        label-empty = "Empty";
        label-empty-foreground = "#707880";
      };
    };
  };
}
