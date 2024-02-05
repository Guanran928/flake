{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.myFlake.home-manager.terminal;
in {
  # 3 terminals, one module.
  #     -- The Orange Box (wtf)

  # FAQ (for future myself):
  #
  # - Q: font?
  #   A: use fontconfig.
  #
  # - Q: WezTerm?
  #   A: - I don't use it.
  #      - I don't know Lua.
  #      - extraConfig is probably not enough if you want customize it yourself.
  #
  # - Q: which terminal should I use?
  #   A: - Alacritty  - rusty
  #      - Foot       - fast
  #      - Kitty      - feature rich
  #
  # - Q: why does kitty's font look bold
  #   A: I dont know, might be related to this: https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.text_composition_strategy

  options = {
    myFlake.home-manager.terminal = {
      cursorStyle = lib.mkOption {
        type = lib.types.enum ["block" "beam" "underline"];
        default = "beam";
        example = "block";
        description = "Select desired terminal cursor style.";
      };

      fontSize = lib.mkOption {
        type = lib.types.int;
        default = 12;
        example = 8;
        description = "Select desired terminal font size.";
      };

      padding = lib.mkOption {
        type = lib.types.int;
        default = 0;
        example = config.myFlake.home-manager.terminal.fontSize;
        description = "Select desired terminal padding size (in px).";
      };
    };
  };

  config = {
    programs = {
      alacritty.settings = {
        import = [
          "${pkgs.vimPlugins.tokyonight-nvim}/extras/alacritty/tokyonight_night.toml"
        ];
        cursor.style = cfg.cursorStyle;
        font.size = cfg.fontSize;
        window.padding.x = cfg.padding;
        window.padding.y = cfg.padding;
      };

      kitty.settings = {
        include =
          lib.mkIf (config.myFlake.home-manager.colorScheme == "tokyonight")
          "${pkgs.vimPlugins.tokyonight-nvim}/extras/kitty/tokyonight_night.conf";
        cursor_shape = cfg.cursorStyle;
        font_size = cfg.fontSize;
        window_padding_width = builtins.toString (cfg.padding * (3.0 / 4.0)); # px -> pt
      };

      foot.settings = {
        main.include =
          lib.mkIf (config.myFlake.home-manager.colorScheme == "tokyonight")
          "${pkgs.vimPlugins.tokyonight-nvim}/extras/foot/tokyonight_night.ini";
        cursor.style = cfg.cursorStyle;
        main.font = "monospace:size=${builtins.toString cfg.fontSize}";
        main.pad = "${builtins.toString cfg.padding}x${builtins.toString cfg.padding}";
      };
    };
  };
}
