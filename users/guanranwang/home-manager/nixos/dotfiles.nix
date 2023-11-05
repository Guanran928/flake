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
    "hypr" = {
      source = "${configPath}/hyprland";
      recursive = true;
    };
    "picom" = {
      source = "${configPath}/picom";
      recursive = true;
    };
    "rofi" = {
      source = "${configPath}/rofi";
      recursive = true;
    };

    "makepkgs.conf" = {
      source = "${configPath}/makepkgs.conf";
    };
    "alsoft.conf" = {
      source = "${configPath}/alsoft.conf";
    };
  };

  xdg.dataFile = {
    "backgrounds" = {
      source = "${dataPath}/backgrounds";
      recursive = true;
    };
    "icons" = {
      source = "${dataPath}/icons";
      recursive = true;
    };
    #"flatpak" = {
    #  source = "${dataPath}/flatpak";
    #  recursive = true;
    #};
  };

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
