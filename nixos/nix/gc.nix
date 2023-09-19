{ ... }:

{
  nix = {
    # hard linking
    settings.auto-optimise-store = true;

    # auto delete older NixOS builds
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
      dates = [ "03:45" ];
    };
  };
}
