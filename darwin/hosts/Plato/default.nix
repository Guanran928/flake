# iMac 18,3 (2017)
{...}: {
  imports = [
    ../../profiles/core
    ../../profiles/device-type/desktop

    ../../../users/guanranwang/darwin/profiles/core
    ../../../users/guanranwang/darwin/profiles/device-type/desktop
    ../../../users/guanranwang/darwin/profiles/opt-in/clash-meta-client.nix

    ./hardware.configuration.nix
    ../../hardware/apple/imac/18-3
  ];

  networking.hostName = "Plato";
  time.timeZone = "Asia/Shanghai";
}
