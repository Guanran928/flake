{lib, ...}: {
  nixpkgs.config = {
    # only needed on older version of nvidia
    #nvidia.acceptLicense = true;

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
        "papermc"
        "temurin-bin"
      ];

    allowUnfree = false;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-x11"
        "spotify"
        "broadcom-sta"
        "papermc"
      ];
  };
}
