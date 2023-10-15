{ ... }:

# no i dont actually own a server
{
  imports = [
    ./core.nix
  ];
  boot.plymouth.enable = false;
}