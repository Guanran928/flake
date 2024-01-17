{
  config,
  lib,
  ...
}: {
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme =
        lib.mkIf (config.myFlake.home-manager.colorScheme == "tokyonight")
        "tokyonight";
      editor = {
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        statusline.mode = {
          normal = "--NORMAL--";
          insert = "--INSERT--";
          select = "--SELECT--";
        };
        soft-wrap.enable = true;
        indent-guides.render = true;
        file-picker.hidden = false;
      };
      # i still use these keybinds somethimes, even its hard to reach
      keys.insert = {
        C-left = "move_prev_word_start";
        C-right = "move_next_word_end";
      };
      keys.normal = {
        C-left = "move_prev_word_start";
        C-right = "move_next_word_end";
      };
    };
  };
}
