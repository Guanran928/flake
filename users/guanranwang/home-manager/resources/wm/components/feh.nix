{pkgs, ...}: {
  imports = [./wallpaper.nix];
  home.packages = with pkgs; [feh];
}
