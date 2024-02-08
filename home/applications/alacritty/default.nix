{
  lib,
  pkgs,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings = {
      env.WINIT_X11_SCALE_FACTOR = "1"; # workaround for scaling in X11
      window.option_as_alt = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "Both"; # for zellij on macOS
    };
  };
}
