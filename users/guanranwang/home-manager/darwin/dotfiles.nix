{ ... }:

let
  configPath = ../common/dotfiles/config;
  #dataPath = ../common/dotfiles/data;
  #binPath = ../common/dotfiles/bin;
in
{
  xdg.configFile = {
    "fish" = {
      source = "${configPath}/fish";
      recursive = true;
    };
  };
}