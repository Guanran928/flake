{ ... }:

{
  nix = {
    ### Auto hard linking
    settings.auto-optimise-store = true;

    ### Automatically delete older NixOS builds
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
