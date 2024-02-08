{
  programs.alacritty = {
    enable = true;
    settings = {
      env.WINIT_X11_SCALE_FACTOR = "1"; # workaround for scaling in X11
      window.option_as_alt = "Both"; # for zellij on macOS
    };
  };
}
