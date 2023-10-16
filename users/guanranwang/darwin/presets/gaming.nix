{ ... }:

{
  imports = [
    ./desktop.nix
  ];
  ### home-manager
  home-manager.users.guanranwang = import ../../home-manager/darwin/presets/gaming.nix; # NOTE: using flakes
}