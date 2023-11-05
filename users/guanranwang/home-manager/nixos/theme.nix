{
  pkgs,
  config,
  ...
}: {
  gtk.enable = true;
  gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

  ### Cursor
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 24;
  };
  # gtk.cursorTheme is unneeded
  # https://github.com/nix-community/home-manager/blob/8765d4e38aa0be53cdeee26f7386173e6c65618d/modules/config/home-cursor.nix#L179C33-L179C33

  ### Icon
  gtk = {
    iconTheme = {
      #name = "Tela-dracula-dark";
      #package = pkgs.tela-icon-theme;
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  ### Font
  gtk.font.name = "Sans";

  ### GTK theme
  gtk.theme = {
    name = "adw-gtk3-dark";
    package = pkgs.adw-gtk3;
  };

  ### Dconf
  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      "titlebar-font" = "Sans Bold";
    };
    "org/gnome/desktop/interface" = {
      "document-font-name" = "Sans";
      "monospace-font-name" = "Monospace";
      # "font-name" is unneeded
      # https://github.com/nix-community/home-manager/blob/8765d4e38aa0be53cdeee26f7386173e6c65618d/modules/misc/gtk.nix#L237C19-L237C19

      "clock-format" = "12h";
      "color-scheme" = "prefer-dark";
      "button-layout" = "icon,appmenu:"; # remove csd window buttons

      # i want to split dconf but
      #
      # error: attribute '"org/gnome/desktop/interface"' already defined at /nix/store/cjr3qn1kg0z268dnbmc2vry4sbgqvnvm-source/users/guanranwang/home-manager/nixos/theming.nix:52:5
      #
      # at /nix/store/cjr3qn1kg0z268dnbmc2vry4sbgqvnvm-source/users/guanranwang/home-manager/nixos/theming.nix:36:5:
      #
      #     35|     };
      #     36|     "org/gnome/desktop/interface" = {
      #       |     ^
      #     37|       "document-font-name" = "Sans";
    };
  };

  # Misc
  xresources.properties = {
    # Cursor
    "Xcursor.theme" = "Adwaita";

    # Fonts
    "Xft.autohint" = "0";
    "Xft.lcdfilter" = "lcddefault";
    "Xft.hintstyle" = "hintslight";
    "Xft.hinting" = "1";
    "Xft.antialias" = "1";
    "Xft.rgba" = "rgb";

    # Tokyonight color scheme
    # i have no idea what does it apply to
    "*background" = "#1a1b26";
    "*foreground" = "#c0caf5";

    "*color0" = "#15161e";
    "*color1" = "#f7768e";
    "*color2" = "#9ece6a";
    "*color3" = "#e0af68";
    "*color4" = "#7aa2f7";
    "*color5" = "#bb9af7";
    "*color6" = "#7dcfff";
    "*color7" = "#a9b1d6";

    "*color8" = "#414868";
    "*color9" = "#f7768e";
    "*color10" = "#9ece6a";
    "*color11" = "#e0af68";
    "*color12" = "#7aa2f7";
    "*color13" = "#bb9af7";
    "*color14" = "#7dcfff";
    "*color15" = "#c0caf5";
  };
}
