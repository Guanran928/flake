# iMac 18,3 (2017)
{...}: {
  imports = [
    ../../profiles/desktop

    ../../../users/guanranwang/darwin/profiles/desktop
    ../../../users/guanranwang/darwin/profiles/common/opt-in/clash-meta-client.nix

    ./hardware-configuration.nix
  ];

  networking.hostName = "Plato";
  time.timeZone = "Asia/Shanghai";
  system.stateVersion = 4;
}
