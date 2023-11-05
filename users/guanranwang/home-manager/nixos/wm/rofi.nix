{pkgs, ...}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "monospace";
    terminal = "${pkgs.alacritty}/bin/alacritty";
  };

  home.packages = with pkgs; [rofi-power-menu];

  # Yes, because I have no idea how to use programs.rofi.theme
  xdg.configFile."rofi" = {
    source = ../../resources/dotfiles/config/rofi;
    recursive = true;
  };
}
