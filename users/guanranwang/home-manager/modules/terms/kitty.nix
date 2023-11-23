{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.myFlake.home-manager.terminal;
in {
  programs.kitty = {
    enable = true;
    settings = {
      include =
        lib.mkIf (config.myFlake.home-manager.colorScheme == "tokyonight")
        "${pkgs.vimPlugins.tokyonight-nvim}/extras/kitty/tokyonight_night.conf";
      cursor_shape = cfg.cursorStyle;
      font_size = cfg.fontSize;
      window_padding_width = builtins.toString (cfg.padding * (3.0 / 4.0)); # px -> pt

      confirm_os_window_close = 0;
    };
  };
}
