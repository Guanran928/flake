{pkgs, ...}: {
  services.picom = {
    enable = true;
    package = pkgs.picom.overrideAttrs (old: {
      src = pkgs.fetchFromGitHub {
        owner = "FT-Labs";
        repo = "picom";
        rev = "ad8feaad127746beaf2afe2b2ea37e7af204a2ac";
        sha256 = "sha256-3lZ41DkNi7FVyEwvMaWwOjLD2aZ6DxZhhvVQMnU6JrI=";
      };
      buildInputs = old.buildInputs ++ [pkgs.pcre2];
    });
    settings = {
      # Animations
      animations = true;
      animation-for-open-window = "zoom";
      animation-for-unmap-window = "squeeze";
      animation-for-transient-window = "slide-down";

      # Blur
      blur-method = "dual_kawase";
      blur-strength = 10;

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
