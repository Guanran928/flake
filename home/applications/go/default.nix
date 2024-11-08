{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    go
    gopls
  ];

  xdg.configFile."go/env".text = ''
    GOPATH=${config.xdg.cacheHome}/go
    GOBIN=${config.xdg.stateHome}/go/bin
  '';
}
