{
  lib,
  pkgs,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings = {
      import = ["${pkgs.vimPlugins.tokyonight-nvim}/extras/alacritty/tokyonight_night.yml"];
      cursor.style = "beam";
      env.WINIT_X11_SCALE_FACTOR = "1";
      window = {
        #opacity = 0.9;
        padding = {
          x = 12;
          y = 12;
        };
      };
      font = {
        size = 12;
        normal = {
          family = lib.mkDefault "monospace"; # macOS dont have fontconfig, so mkDefault is nessesary
          style = "SemiBold";
        };
        bold = {
          family = lib.mkDefault "monospace";
          style = "Bold";
        };
        bold_italic = {
          family = lib.mkDefault "monospace";
          style = "Bold Itailc";
        };
        italic = {
          family = lib.mkDefault "monospace";
          style = "SemiBold Italic";
        };
      };
    };
  };
}
