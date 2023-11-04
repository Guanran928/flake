{...}: {
  imports = [
    ./display-server

    ./fonts.nix
    ./gnome-keyring.nix
    ./graphical.nix
    ./polkit.nix
    ./xdg.nix
  ];
}
