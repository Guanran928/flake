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
    nixfmt
    nixpkgs-review
    sops
    statix
  ];

  # nh
  home.sessionVariables.NH_FLAKE = "/home/guanranwang/Projects/flake";
}
