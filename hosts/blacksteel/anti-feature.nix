{lib, ...}: {
  nixpkgs.config = {
    # only needed on older version of nvidia
    #nvidia.acceptLicense = true;

    allowNonSource = false;
    allowNonSourcePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "adoptopenjdk-hotspot-bin"
        "cargo-bootstrap"
        "minecraft-server"
        "rustc-bootstrap"
        "rustc-bootstrap-wrapper"
        "sof-firmware"
        "temurin-bin"
      ];

    allowUnfree = false;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "broadcom-sta"
        "minecraft-server"
      ];
  };
}
