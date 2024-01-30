{
  pkgs,
  inputs,
  ...
}: {
  services.picom = {
    enable = true;
    package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.picom-ft-labs;
    settings = {
      # Animations
      animations = true;
      animation-for-open-window = "zoom";
      animation-for-unmap-window = "squeeze";
      animation-for-transient-window = "slide-down";

      # Blur
      blur-method = "dual_kawase";
      blur-strength = 10;
      blur-background-exclude = [
        "_GTK_FRAME_EXTENTS@:c"
      ];

      # Corners
      corner-radius = 12;
      rounded-corners-exclude = [
        "class_g = 'Polybar'"
      ];

      # Opacity
      opacity-rule = [
        "100:_NET_WM_STATE@:32a = '_NET_WM_STATE_FULLSCREEN'"
        "90:class_g = 'Polybar'"
        "90:class_g = 'Rofi'"
        "90:class_g = 'Alacritty'"
      ];

      # Shadow
      shadow = true;
      shadow-exclude = [
        "_GTK_FRAME_EXTENTS@:c"
      ];

      # Misc
      backend = "glx";
      glx-no-rebind-pixmap = true;
      glx-no-stencil = true;
      vsync = true;
      unredir-if-possible = true;
    };
  };
}
