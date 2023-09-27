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

  #                                             users,user,       flake,       os.
  home-manager.users.guanranwang = import ../../users/guanranwang/home-manager/darwin; # NOTE: using flakes
}