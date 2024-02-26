{
  networking.knownNetworkServices = [
    "Wi-Fi"
    "Bluetooth PAN"
    "Thunderbolt Bridge"
  ];

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";
}
