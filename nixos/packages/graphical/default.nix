{...}: {
  imports = [
    ./display-server

    ./gnome-keyring.nix
    ./graphical.nix
    ./polkit.nix
    ./xdg.nix
  ];
}
