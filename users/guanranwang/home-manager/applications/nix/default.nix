{pkgs, ...}: {
  home.packages = with pkgs; [
    nil # LSP
    alejandra # Formatter
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
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
    ];
  };
}
