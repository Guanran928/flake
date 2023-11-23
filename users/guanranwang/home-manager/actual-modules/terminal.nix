{lib, ...}: {
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
    };
  };
}
