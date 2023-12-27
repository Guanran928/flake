{
  pkgs,
  inputs,
  ...
}: let
  nom = inputs.nix-monitored.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  nix.package = nom;
  nixpkgs.overlays = [
    (_self: super: {
      nixos-rebuild = super.nixos-rebuild.override {
        nix = super.nom;
      };
      nix-direnv = super.nix-direnv.override {
        nix = super.nom;
      };
    })
  ];
}
