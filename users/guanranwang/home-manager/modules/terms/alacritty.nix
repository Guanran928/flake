{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.myFlake.home-manager.terminal;
in {
  programs.alacritty = {
    enable = true;
    settings = {
      import =
        lib.mkIf (config.myFlake.home-manager.colorScheme == "tokyonight")
        ["${pkgs.vimPlugins.tokyonight-nvim}/extras/alacritty/tokyonight_night.yml"];
      cursor.style = cfg.cursorStyle;
      font.size = cfg.fontSize;
      window.padding.x = cfg.padding;
      window.padding.y = cfg.padding;

      #env.WINIT_X11_SCALE_FACTOR = "1"; # workaround for.. something?
    };
  };
}
