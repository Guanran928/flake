{pkgs, ...}: {
  home.packages = with pkgs; [
    # LSP / Formatters / Linters
    nil
    alejandra
    statix
    deadnix

    # Nix helper
    nh
    # Secret management
    sops
    # Additional information while building
    nix-output-monitor
  ];

  ### VSCode
  programs.vscode = {
    userSettings = {
      # Extensions
      ## Nix IDE
      nix.enableLanguageServer = true;
      ### For "nixd" LSP
      nix.serverPath = "nil";
      nix.serverSettings.nil = {
        formatting.command = ["alejandra"];
        nix.flake.autoArchive = true;
      };
    };
    extensions = [pkgs.vscode-extensions.jnoortheen.nix-ide];
  };
}
