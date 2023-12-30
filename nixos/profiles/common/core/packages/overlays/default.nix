_: let
  addPatches = pkg: patches:
    pkg.overrideAttrs (old: {
      patches = (old.patches or []) ++ patches;
    });
in {
  nixpkgs.overlays = [
    (import ./nautilus.nix {inherit addPatches;})
    (import ./prismlauncher.nix {inherit addPatches;})
    (import ./sway.nix {inherit addPatches;})
  ];
}
