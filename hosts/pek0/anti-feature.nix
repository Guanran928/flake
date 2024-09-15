{ lib, ... }:
{
  nixpkgs.config = {
    allowNonSource = false;
    allowNonSourcePredicate =
      pkg:
      lib.elem (lib.getName pkg) [
        "cargo-bootstrap"
        "go"
        "minecraft-server"
        "rustc-bootstrap"
        "rustc-bootstrap-wrapper"
        "sof-firmware"
        "temurin-bin"
      ];

    allowUnfree = false;
    allowUnfreePredicate =
      pkg:
      lib.elem (lib.getName pkg) [
        "broadcom-sta"
        "minecraft-server"
      ];
  };
}
