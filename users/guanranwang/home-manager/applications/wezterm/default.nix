_: {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        color_scheme = "Tokyo Night",
        default_cursor_style = 'SteadyBar',
        window_padding = {
          left = "12px",
          right = "12px",
          top = "12px",
          bottom = "12px",
        },
      }
    '';
  };
}
