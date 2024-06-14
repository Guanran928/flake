# iMac 18,3 (2017)
{...}: {
  imports = [
    ../../darwin/profiles/desktop
    ../../darwin/profiles/common/opt-in/mihomo.nix

    ./hardware-configuration.nix
  ];

  networking.hostName = "plato";
  time.timeZone = "Asia/Shanghai";
  system.stateVersion = 4;
}
