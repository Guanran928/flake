{ pkgs, ... }:
{
  home.packages = with pkgs; [
    deadnix
    nh
    nil
    nix-diff
    nix-index
    nix-init
    nix-output-monitor
    nix-tree
    nix-update
    nixfmt-rfc-style
    nixpkgs-review
    sops
    statix
  ];

  # nh
  home.sessionVariables.FLAKE = "/home/guanranwang/Projects/flake";
}
