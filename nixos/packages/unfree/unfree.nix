{ lib, ... }:


{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11"              # ../hardware/gpu/nvidia.nix
    #"nvidia-settings"
    #"nvidia-persistenced"
    "xow_dongle-firmware"     # ../hardware/accessories/xbox.nix
    "facetimehd-firmware"     # ../hardware/hardwares/imac-2017.nix

    # flatpak-able
    "discord"
    "google-chrome"
    "lunar-client"
    "osu-lazer-bin"
    "osu-lazer-bin-2023.1008.0" # what?
    "spotify"
    "steam"
    "steam-original"
    "microsoft-edge-stable"
    "qq"
  ];
}
