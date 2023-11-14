{pkgs, ...}: {
  imports = [./wallpaper.nix];
  home.packages = with pkgs; [swww];
}
