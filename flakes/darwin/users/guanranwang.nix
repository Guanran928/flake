{ pkgs, ... }:

{
  users.users.guanranwang = {
    createHome = true;
    description = "Guanran Wang";
    home = "/Users/guanranwang";
    shell = pkgs.fish;
  };
}