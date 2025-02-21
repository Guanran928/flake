{ lib, ... }:
{
  nixpkgs.config = {
    # FIXME: dotnet
    allowNonSourcePredicate = _pkg: true;

    allowUnfreePredicate =
      pkg:
      lib.elem (lib.getName pkg) [
        "broadcom-sta"
        "minecraft-server"
      ];

    permittedInsecurePackages = [ "olm-3.2.16" ];
  };
}
