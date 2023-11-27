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


  ### Flakes
  imports = [
    ../../../../../darwin/flake-modules/home-manager.nix
  ];

  ### home-manager
  home-manager.users.guanranwang.imports = map (n: ../../../home-manager/${n}) [
    "default.nix"
    "profiles/command-line/darwin"
  ];
}
