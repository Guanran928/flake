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
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    ### optimiser
    optimise = {
      automatic = true;
      dates = [ "03:45" ];
    };
  };
}
