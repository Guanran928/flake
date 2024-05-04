let
  addPatches = pkg: patches:
    pkg.overrideAttrs (old: {
      patches = (old.patches or []) ++ patches;
    });
in {
  patches = _final: prev:
    {}
    // import ./nautilus.nix {inherit addPatches prev;}
    // import ./prismlauncher.nix {inherit addPatches prev;}
    // import ./sway.nix {inherit addPatches prev;}
    // import ./fcitx5.nix {inherit addPatches prev;};
}
