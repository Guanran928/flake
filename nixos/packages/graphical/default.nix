{ ... }:

{
  imports = [
    ./display-server

    #./flatpak.nix
    ./fonts.nix
    ./gnome-keyring.nix
    ./graphical.nix
    ./polkit.nix
    ./xdg.nix
  ];
}
