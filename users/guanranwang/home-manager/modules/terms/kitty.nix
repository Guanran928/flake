{pkgs, ...}: {
  programs.kitty = {
    enable = true;
    settings = {
      include = "${pkgs.vimPlugins.tokyonight-nvim}/extras/kitty/tokyonight_night.conf";
      font_size = 12;
      confirm_os_window_close = 0;
      window_padding_width = 6;
      adjust_line_height = 0;
    };
  };
}
