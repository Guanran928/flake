{pkgs, ...}: {
  home.packages = with pkgs; [
    # LSP / Formatters / Linters
    nil
    alejandra
    statix
    deadnix
    nixpkgs-fmt # for nixpkgs PRs

    # Nix helper
    nh
    # Secret management
    sops
    # Additional information while building
    nix-output-monitor
  ];

  ### nh
  # yes, i know, weird and long path
  home.sessionVariables.FLAKE = "/home/guanranwang/Documents/Projects/git-repos/github.com/Guanran928/flake";

  ### VSCode
  programs.vscode = {
    extensions = [pkgs.vscode-extensions.jnoortheen.nix-ide];
    userSettings.nix = {
      enableLanguageServer = true;
      serverPath = "nil";
      serverSettings.nil = {
        formatting.command = ["alejandra"];
        nix.flake.autoArchive = true;
      };
    };
  };
}
