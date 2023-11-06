{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    ### Compiler
    go
    ### LSP
    gopls
  ];

  # Make Go follow XDG
  # "$HOME/go"...
  xdg.configFile = {
    "go/env".text = ''
      GOPATH=${config.xdg.cacheHome}/go
      GOBIN=${config.xdg.stateHome}/go/bin
    '';
  };
}
