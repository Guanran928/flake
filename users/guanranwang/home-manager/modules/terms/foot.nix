{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.foot = let
    cfg = config.myFlake.home-manager.terminal;
  in {
    enable = true;
    settings = {
      main.include =
        lib.mkIf (config.myFlake.home-manager.colorScheme == "tokyonight")
        "${pkgs.vimPlugins.tokyonight-nvim}/extras/foot/tokyonight_night.ini";
      cursor.style = cfg.cursorStyle;
      main.font = "monospace:size=${builtins.toString cfg.fontSize}";
      main.pad = "${builtins.toString cfg.padding}x${builtins.toString cfg.padding}";
    };
  };
}
