{lib, ...}: {
  nixpkgs.config = {
    allowAliases = false;

    allowNonSource = false;
    allowNonSourcePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "adoptopenjdk-hotspot-bin"
        "cargo-bootstrap"
        "cef-binary"
        "osu-lazer-bin"
        "rustc-bootstrap"
        "rustc-bootstrap-wrapper"
        "sof-firmware"
        "spotify"
        "temurin-bin"
      ];

    allowUnfree = false;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "libXNVCtrl"
        "nvidia-x11"
        "osu-lazer-bin"
        "spotify"
        "steam"
        "steam-original"
        "xow_dongle-firmware"
      ];
  };
}
