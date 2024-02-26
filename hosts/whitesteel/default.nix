{...}: {
  imports = [
    ../../darwin/profiles/desktop
    ../../darwin/profiles/common/opt-in/clash-meta-client.nix

    ./hardware-configuration.nix
  ];

  networking.hostName = "whitesteel";
  time.timeZone = "Asia/Shanghai";
  system.stateVersion = 4;
}
