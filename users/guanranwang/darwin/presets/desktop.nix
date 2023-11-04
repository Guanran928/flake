{...}: {
  imports = [
    ./core.nix

    ### Flakes
    ../../../../flakes/darwin/home-manager.nix
  ];
  ### home-manager
  home-manager.users.guanranwang = import ../../home-manager/darwin/presets/desktop.nix; # NOTE: using flakes
}
