{
  pkgs,
  config,
  lib,
  ...
}:
{
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
  };

  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      "color-scheme" = "prefer-dark";
    };

    # Make GTK listen to fontconfig
    "org/gnome/desktop/wm/preferences" = {
      "titlebar-font" = "Sans Bold 11";
    };
    "org/gnome/desktop/interface" = {
      "font-name" = "Sans 11";
      "document-font-name" = "Sans 11";
      "monospace-font-name" = "Monospace 10";
    };
  };

  # https://github.com/nix-community/home-manager/commit/e9b9ecef4295a835ab073814f100498716b05a96
  xdg.configFile."gtk-4.0/gtk.css".text = lib.mkForce config.gtk.gtk4.extraCss;

  # Declutter $HOME
  home.file.".icons/default/index.theme".enable = false;
  home.file.".icons/${config.home.pointerCursor.name}".enable = false;

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "gtk3";
  };
}
