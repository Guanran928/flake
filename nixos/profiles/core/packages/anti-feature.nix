{lib, ...}: {
  nixpkgs.config = {
    allowBroken = false;
    allowUnsupportedSystem = false;

    allowNonSource = false;
    allowNonSourcePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "vscodium"
        "spotify"
        "adoptopenjdk-hotspot-bin"
        "osu-lazer-bin-2023.1026.0"
        "protonup-qt-2.8.2"
        "cef-binary"
        "virtualbox"
        "virtualbox-modules"
        "open-watcom-bin"
        "open-watcom-bin-unwrapped"
        "sof-firmware"
      ];

    allowUnfree = false;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-x11"
        #"nvidia-settings"
        #"nvidia-persistenced"
        #"xow_dongle-firmware"
        #"facetimehd-firmware"
        "osu-lazer-bin-2023.1026.0"
        "spotify"
        "steam"
        "steam-original"
      ];
  };
}
