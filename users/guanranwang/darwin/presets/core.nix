{pkgs, ...}: {
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

  imports = [
    ../../../../flakes/darwin/home-manager.nix
  ];

  home-manager.users.guanranwang.imports = [
    ../..
    ../../profiles/command-line/darwin
  ];
}
