{ pkgs, ... }:

{
  users = {
    knownUsers = [ "guanranwang" ];
    users."guanranwang" = {
      createHome = true;
      description = "Guanran Wang";
      home = "/Users/guanranwang";
      shell = pkgs.fish;
      uid = 501;
    };
  };

  # Flakes
  imports = [
    ../../../../flakes/darwin/home-manager.nix
  ];
  ### home-manager
  home-manager.users.guanranwang = import ../../home-manager/darwin/presets/desktop.nix; # NOTE: using flakes
}