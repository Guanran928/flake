{pkgs, ...}: {
  networking.stevenblack.enable = true;
  services.system76-scheduler.enable = true;
  services.power-profiles-daemon.enable = true;
  services.thermald.enable = true;

  # YubiKey
  services.udev.packages = [pkgs.yubikey-personalization];
}
