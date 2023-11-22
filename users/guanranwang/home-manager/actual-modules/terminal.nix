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
        default = 12;
        example = 8;
        description = "Select desired terminal padding size (in px).";
      };

      colorScheme = lib.mkOption {
        type = lib.types.enum [null "tokyonight"];
        default = "tokyonight";
        description = "Select desired terminal color scheme.";
      };
    };
  };

  config.programs = lib.mkMerge [
    {
      alacritty.settings.cursor.style = cfg.cursorStyle;
      kitty.settings.cursor_shape = cfg.cursorStyle;
      foot.settings.cursor.style = cfg.cursorStyle;

      alacritty.settings.font.size = cfg.fontSize;
      kitty.settings.font_size = cfg.fontSize;
      foot.settings.main.font = "monospace:size=${builtins.toString cfg.fontSize}";

      alacritty.settings.window.padding.x = cfg.padding;
      alacritty.settings.window.padding.y = cfg.padding;
      kitty.settings.window_padding_width = builtins.toString (cfg.padding * (3.0 / 4.0)); # px -> pt
      foot.settings.main.pad = "${builtins.toString cfg.padding}x${builtins.toString cfg.padding}";
    }

    # TODO: split this part to ./color-scheme.nix (???)
    (lib.mkIf (cfg.colorScheme == "tokyonight") {
      alacritty.settings.import = ["${pkgs.vimPlugins.tokyonight-nvim}/extras/alacritty/tokyonight_night.yml"];
      kitty.settings.include = "${pkgs.vimPlugins.tokyonight-nvim}/extras/kitty/tokyonight_night.conf";
      foot.settings.main.include = "${pkgs.vimPlugins.tokyonight-nvim}/extras/foot/tokyonight_night.ini";
    })
  ];
}
