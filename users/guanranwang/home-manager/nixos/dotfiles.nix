{...}: let
  homePath = ../common/dotfiles;
  binPath = ../common/dotfiles/bin;
  configPath = ../common/dotfiles/config;
  dataPath = ../common/dotfiles/data;
in {
  xdg.configFile = {
    "foot" = {
      source = "${configPath}/foot";
      recursive = true;
    };
    "fish" = {
      source = "${configPath}/fish";
      recursive = true;
    };
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
    "dunst" = {
      source = "${configPath}/dunst";
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
