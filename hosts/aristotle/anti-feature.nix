{lib, ...}: {
  nixpkgs.config = {
    allowNonSource = false;
    allowNonSourcePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "adoptopenjdk-hotspot-bin"
        "cargo-bootstrap"
        "cef-binary"
        "rustc-bootstrap"
        "rustc-bootstrap-wrapper"
        "sof-firmware"
        "spotify"
        "vscodium"
        "temurin-bin"
      ];

    allowUnfree = false;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-x11"
        "spotify"
        "steam"
        "steam-original"
        "xow_dongle-firmware"
      ];
  };
}
