{...}: {
  imports = [
    ./hardware.nix # TODO: move this somewhere else?

    # TODO: should this be considered user-specific?
    ./overlays
    ./unfree
  ];
}
