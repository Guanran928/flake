{ ... }:

{
  imports = [
    ./security.nix

    ./gnome-keyring.nix
    ./machine-id.nix
    ./polkit.nix
    ./sysctl.nix
    ./tpm.nix
  ];
}