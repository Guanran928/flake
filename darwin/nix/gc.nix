{ ... }:

{
  nix = {
    ### optimiser
    settings = {
      auto-optimise-store = true;
    };

    ### auto delete older NixOS builds
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
