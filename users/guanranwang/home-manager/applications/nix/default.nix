{pkgs, ...}: {
  home.packages = with pkgs; [
    nil # LSP
    alejandra # Formatter
    statix # Linter
    sops
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
