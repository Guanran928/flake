let
  addPatches = pkg: patches:
    pkg.overrideAttrs (old: {
      patches = (old.patches or []) ++ patches;
    });
in {
  nautilus = import ./nautilus.nix {inherit addPatches;};
  prismlauncher = import ./prismlauncher.nix {inherit addPatches;};
  sway = import ./sway/git;
}
