{ ... }:

{
  imports = [
    ../../flakes/darwin/main.nix
  ];
  networking.knownNetworkServices = [
    "Ethernet"
    "Wi-Fi"
    "Thunderbolt Bridge"
    "Thunderbolt Bridge 2"
    "iPhone USB"
  ];
  networking.hostName = "iMac-macOS";

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";
}