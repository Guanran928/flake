{ ... }:

{
  imports = [
    #./nautilus.nix patch is for nautilus 45, nixpkgs still at nautilus 44
    ./sway.nix
    ./prismlauncher.nix
  ];
}