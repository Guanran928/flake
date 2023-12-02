_: {
  nix = {
    ### Auto hard linking
    settings.auto-optimise-store = true;

    ### Automatically delete older NixOS builds
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
