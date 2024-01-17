{
  inputs,
  pkgs,
  ...
}: {
  ### Options
  home-manager.users.guanranwang = import ./home;

  imports = [
    ./nix
    ./anti-features.nix
    ./networking.nix

    inputs.self.darwinModules.default
    inputs.home-manager.darwinModules.home-manager
  ];

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

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;}; # ??? isnt specialArgs imported by default ???
  };
}
