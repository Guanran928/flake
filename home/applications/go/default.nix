{ pkgs, config, ... }:
{
  programs.go.enable = true;
  home.packages = with pkgs; [
    gopls
    delve
    go-tools
  ];

  xdg.configFile = {
    "go/env".text = ''
      GOPATH=${config.xdg.cacheHome}/go
      GOBIN=${config.xdg.stateHome}/go/bin
    '';
  };
}
