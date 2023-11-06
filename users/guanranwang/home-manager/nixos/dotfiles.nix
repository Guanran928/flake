{...}: let
  homePath = ../resources/dotfiles;
  binPath = ../resources/dotfiles/bin;
  configPath = ../resources/dotfiles/config;
  dataPath = ../resources/dotfiles/data;
in {
  xdg.configFile = {
    "fontconfig" = {
      source = "${configPath}/fontconfig";
      recursive = true;
    };
    #"picom" = {
    #  source = "${configPath}/picom";
    #  recursive = true;
    #};
    #"makepkgs.conf" = {
    #  source = "${configPath}/makepkgs.conf";
    #};
    #"alsoft.conf" = {
    #  source = "${configPath}/alsoft.conf";
    #};
  };

  xdg.dataFile = {
    "backgrounds" = {
      source = "${dataPath}/backgrounds";
      recursive = true;
    };
    #"flatpak" = {
    #  source = "${dataPath}/flatpak";
    #  recursive = true;
    #};
  };

  home.sessionPath = ["$HOME/.local/bin"];
  home.file = {
    ".local/bin" = {
      source = "${binPath}";
      recursive = true;
    };
    ".drirc" = {
      source = "${homePath}/.drirc";
      recursive = true;
    };
    ".xinitrc" = {
      source = "${homePath}/.xinitrc";
      recursive = true;
    };
  };
}
