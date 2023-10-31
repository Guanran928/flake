{ lib, ... }:


{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11"              # ../hardware/gpu/nvidia.nix
    #"nvidia-settings"
    #"nvidia-persistenced"
    "xow_dongle-firmware"     # ../hardware/accessories/xbox.nix
    "facetimehd-firmware"     # ../hardware/hardwares/imac-2017.nix

    "osu-lazer-bin-2023.1026.0" # what?
    "spotify"
    "steam"
    "steam-original"
    #"discord"
    #"google-chrome"
    #"lunar-client"
    #"microsoft-edge-stable"
    #"qq"
  ];
}
