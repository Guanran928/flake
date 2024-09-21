{ lib, ... }:
{
  nixpkgs.config = {
    allowNonSource = false;
    allowNonSourcePredicate =
      pkg:
      lib.elem (lib.getName pkg) [
      ];

    allowUnfree = false;
    allowUnfreePredicate = pkg: lib.elem (lib.getName pkg) [ ];

    permittedInsecurePackages = [
    ];
  };
}
