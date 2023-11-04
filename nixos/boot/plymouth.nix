{lib, ...}: {
  boot.plymouth.enable = lib.mkDefault true; # mkDefault for headless devices, check out server.nix
}
