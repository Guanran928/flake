{
  pkgs,
  config,
  ...
}: {
  programs.go.enable = true;

  home.packages = with pkgs; [
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
