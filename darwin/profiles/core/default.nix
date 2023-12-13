{inputs, ...}: {
  imports = [
    ../../modules
    ./nix
    ./anti-features.nix

    inputs.home-manager.darwinModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;}; # ??? isnt specialArgs imported by default ???
  };
}
