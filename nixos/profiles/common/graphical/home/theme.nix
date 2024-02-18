{
  pkgs,
  config,
  lib,
  ...
}: {
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 24;
    x11.enable = true;
    gtk.enable = true;
  };

  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    gtk3.bookmarks = [
      "file://${config.home.homeDirectory}/Documents/Projects/git-repos/github.com/Guanran928/flake"
    ];

    iconTheme = {
      #name = "Tela-dracula-dark";
      #package = pkgs.tela-icon-theme;
      #name = "Papirus-Dark";
      #package = pkgs.papirus-icon-theme;
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };

    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
  };

  dconf.settings."org/gnome/desktop/interface"."color-scheme" = "prefer-dark";

  # ??? this commit broke nautilus's spacing ???
  # https://github.com/nix-community/home-manager/commit/e9b9ecef4295a835ab073814f100498716b05a96
  xdg.configFile."gtk-4.0/gtk.css".text = lib.mkForce config.gtk.gtk4.extraCss;
}
