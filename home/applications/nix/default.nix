{pkgs, ...}: {
  home.packages = with pkgs; [
    # lsp
    alejandra
    deadnix
    nil
    statix

    # nixpkgs PRs
    nix-init
    nix-update
    nixfmt-rfc-style
    nixpkgs-review

    # misc
    colmena
    comma
    nh
    nix-index
    nix-output-monitor
    nix-tree
    sops
  ];

  # nh
  home.sessionVariables.FLAKE = "/home/guanranwang/Documents/Projects/flake";
}
