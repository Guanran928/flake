{
  pkgs,
  config,
  ...
}: {
  programs.go.enable = true;
  home.packages = with pkgs; [
    gopls # lsp
    delve # debugger
    go-tools # linter and static analysis
  ];
  ### VSCode
  programs.vscode.extensions = with pkgs.vscode-extensions; [golang.go];

  # Make Go follow XDG
  # "$HOME/go"...
  xdg.configFile = {
    "go/env".text = ''
      GOPATH=${config.xdg.cacheHome}/go
      GOBIN=${config.xdg.stateHome}/go/bin
    '';
  };
}
