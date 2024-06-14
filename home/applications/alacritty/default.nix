{
  lib,
  pkgs,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings = {
      import = [
        "${pkgs.vimPlugins.tokyonight-nvim}/extras/alacritty/tokyonight_night.toml"
      ];

      cursor.style = "beam";
      font.size = 10;

      # workaround for scaling in X11
      env.WINIT_X11_SCALE_FACTOR = "1";

      # for zellij on macOS
      window.option_as_alt = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "Both";
    };
  };
}
