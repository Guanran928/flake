{ lib, ... }:
{
  nixpkgs.config = {
    allowNonSource = false;
    allowNonSourcePredicate =
      pkg:
      lib.elem (lib.getName pkg) [
        "cargo-bootstrap"
        "go"
        "rustc-bootstrap"
        "rustc-bootstrap-wrapper"
        "sof-firmware"
      ];

    allowUnfree = false;
    allowUnfreePredicate = pkg: lib.elem (lib.getName pkg) [ ];

    permittedInsecurePackages = [ ];
  };
}
