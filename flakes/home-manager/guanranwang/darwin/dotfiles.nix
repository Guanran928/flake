{ ... }:

let
  configPath = ../common/dotfiles/config;
  #dataPath = ../common/dotfiles/data;
  #binPath = ../common/dotfiles/bin;
in
{
  xdg.configFile = {
    "clash-meta" = {
      source = "${configPath}/clash"; 
      recursive = true;
    };
    "alacritty" = {
      source = "${configPath}/alacritty";
      recursive = true;
    };
    "fish" = {
      source = "${configPath}/fish"; 
      recursive = true;
    };
    "zsh/plugins" = {
      source = "${configPath}/zsh";
      recursive = true;
    };
  };
}