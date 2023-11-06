{pkgs, ...}: {
  home.packages = with pkgs; [
    ### LSP
    nil
  ];

  ### VSCode
  programs.vscode = {
    userSettings = {
      ### Nix IDE
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nil}/bin/nil";
    };
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
    ];
  };
}
