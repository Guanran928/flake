# iMac 18,3 (2017)
_: {
  networking.knownNetworkServices = [
    "Ethernet"
    "Wi-Fi"
    "Thunderbolt Bridge"
    "Thunderbolt Bridge 2"
    "iPhone USB"
  ];

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";
}
