{
  pkgs,
  lib,
  ...
}: {
  users = {
    knownUsers = ["guanranwang"];
    users."guanranwang" = {
      createHome = true;
      description = "Guanran Wang";
      home = "/Users/guanranwang";
      shell = pkgs.fish;
      uid = 501;
    };
  };

  ### Options
  myFlake.darwin.networking.dns.provider = lib.mkDefault "alidns";
  home-manager.users.guanranwang = import ./home;
}
