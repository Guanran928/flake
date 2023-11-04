{lib, ...}: {
  networking.wireless.iwd.enable = lib.mkDefault true;
}
