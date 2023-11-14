{...}: {
  services.picom = {
    enable = true;
    settings = {
      # Corner
      corner-radius = 0;
      round-borders = 0;

      # Shadow
      shadow = true;
      shadow-radius = 15;
      shadow-offset-x = -8;
      shadow-offset-y = -8;
      shadow-opacity = 0.2;
      shadow-exclude = [
        "_GTK_FRAME_EXTENTS@=c"
      ];

      # Fade
      fading = true;
      fade-in-step = 0.04;
      fade-out-step = 0.04;
      fade-delta = 3;

      # Dim inactive window
      inactive-dim = 0;
      focus-exclude = [
        "class_g = 'Rofi'"
      ];

      # Opacity
      frame-opacity = 1;
      active-opacity = 1;
      inactive-opacity = 1;
      dropdown_menu = {opacity = 1;};
      popup_menu = {opacity = 1;};

      opacity-rule = [
        "100=_NET_WM_STATE@=32a = '_NET_WM_STATE_FULLSCREEN'"
        "90=class_g	= 'Polybar'"
        "90=class_g	= 'Rofi'"
        "90=class_g	= 'Alacritty'"
      ];

      # Blur
      blur = {
        method = "dual_kawase";
        strength = 9;
      };
      blur-background-exclude = [
        "_GTK_FRAME_EXTENTS@=c"
        "class_g = 'Main'"
      ];

      backend = "glx";
      vsync = true;
      use-damage = false;
      unredir-if-possible = true;

      wintypes = {
        dropdown_menu = {opacity = 1;};
        tooltip = {
          fade = true;
          shadow = true;
          opacity = 0.1;
          focus = true;
        };
        popup_menu = {opacity = 1;};

        notification = {redir-ignore = true;};
        notify = {redir-ignore = true;};
      };
    };
  };
}
