{...}: {
  nixpkgs.overlays = [
    (import ./nautilus.nix)
    (import ./prismlauncher.nix)
    (import ./sway.nix)
  ];
}
