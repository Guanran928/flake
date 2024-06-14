{pkgs, ...}: {
  home.packages = with pkgs; [
    # lsp
    nil
    alejandra
    statix
    deadnix

    # nixpkgs PRs
    nixfmt-rfc-style
    nix-update
    nix-init

    # misc
    nh
    nix-output-monitor
    nix-index
    comma
    sops
    colmena
  ];

  # for `nh`
  # yes, i know, weird and long path
  home.sessionVariables.FLAKE = "/home/guanranwang/Documents/Projects/git-repos/github.com/Guanran928/flake";
}
