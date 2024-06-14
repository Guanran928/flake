{...}: {
  imports = [
    ../../darwin/profiles/desktop
    ../../darwin/profiles/common/opt-in/mihomo.nix

    ./hardware-configuration.nix
  ];

  networking.hostName = "whitesteel";
  time.timeZone = "Asia/Shanghai";
  system.stateVersion = 4;
}
