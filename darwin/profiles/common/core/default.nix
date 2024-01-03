{inputs, ...}: {
  imports = [
    ./nix
    ./anti-features.nix
    ./networking.nix

    inputs.self.darwinModules.default
    inputs.home-manager.darwinModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;}; # ??? isnt specialArgs imported by default ???
  };
}
