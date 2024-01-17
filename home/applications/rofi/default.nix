{
  pkgs,
  lib,
  ...
}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "monospace";
    terminal = lib.getExe pkgs.alacritty;
  };

  home.packages = with pkgs; [rofi-power-menu];

  # Yes, because I have no idea how to use programs.rofi.theme
  xdg.configFile."rofi" = {
    source = ./rofi;
    recursive = true;
  };
}
