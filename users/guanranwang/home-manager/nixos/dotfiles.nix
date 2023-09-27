{ ... }:

let
  homePath = ../common/dotfiles;
  binPath = ../common/dotfiles/bin;
  configPath = ../common/dotfiles/config;
  dataPath = ../common/dotfiles/data;
  chromiumFlags = ''
    --ozone-platform-hint=auto
    --enable-wayland-ime
    #--gtk-version=4
    --password-store=gnome
    --proxy-server=127.0.0.1:7890
  '';
in
{
  xdg.configFile = {
    "chromium-flags.conf".text = chromiumFlags;
    "chrome-flags.conf".text = chromiumFlags;
    "electron-flags.conf".text = chromiumFlags;
    "code-flags.conf".text = chromiumFlags;
    #"thorium-flags.conf".text = chromiumFlags;

    "alacritty" = {
      source = "${configPath}/alacritty";
      recursive = true;
    };
    "foot" = {
      source = "${configPath}/foot";
      recursive = true;
    };
    "kitty" = {
      source = "${configPath}/kitty";
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
    "zsh/plugins" = {
      source = "${configPath}/zsh";
      recursive = true;
    };
    "mpv" = {
      source = "${configPath}/mpv";
      recursive = true;
    };

    "makepkgs.conf" = {
      source = "${configPath}/makepkgs.conf";
    };
    "alsoft.conf" = {
      source = "${configPath}/alsoft.conf";
    };

    #"waybar" = {
    #  source = "${configPath}/waybar";
    #  recursive = true;
    #};
    #"clash-meta" = {
    #  source = "${configPath}/clash";
    #  recursive = true;
    #};
    #"clash-meta/config.yaml" = {
    #  text = "${config.sops.secrets."clash-config".path}";
    #};
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