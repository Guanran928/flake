{pkgs, ...}: {
  home.packages = with pkgs; [
    gnome.eog
  ];
}
