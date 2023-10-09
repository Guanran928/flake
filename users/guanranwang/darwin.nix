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

  # Flakes.
  home-manager.users.guanranwang = import ./home-manager/darwin; # NOTE: using flakes
}