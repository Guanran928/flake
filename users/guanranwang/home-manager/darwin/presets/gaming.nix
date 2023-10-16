{ pkgs, ... }:

{
  imports = [
    ./desktop.nix
  ];

  home.packages = with pkgs; [
    prismlauncher
  ];
}