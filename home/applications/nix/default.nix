{pkgs, ...}: {
  home.packages = with pkgs; [
    # lsp
    nil
    alejandra
    statix
    deadnix

    # nixpkgs PRs
    nixpkgs-fmt
    # nixfmt-rfc-style
    nix-update

    # misc
    nh
    nix-output-monitor
    nix-index
    comma
    sops
  ];

  # for `nh`
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
