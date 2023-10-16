{ ... }:

{
  imports = [
    ./desktop.nix
  ];

  home-manager.users.guanranwang = import ../../home-manager/nixos/presets/gaming.nix;
}