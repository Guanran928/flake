# iMac 18,3 (2017)
{...}: {
  imports = [
    ../../darwin/profiles/desktop
    ../../darwin/profiles/common/opt-in/mihomo.nix
  ];

  networking.hostName = "plato";
  time.timeZone = "Asia/Shanghai";
  system.stateVersion = 4;
  nixpkgs.hostPlatform = "x86_64-darwin";
}
