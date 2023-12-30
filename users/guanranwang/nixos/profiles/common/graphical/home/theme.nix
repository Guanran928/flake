{
  pkgs,
  config,
  lib,
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

  ### GTK
  gtk.theme = {
    name = "adw-gtk3-dark";
    package = pkgs.adw-gtk3;
  };

  # ??? this commit broke nautilus's spacing ???
  # https://github.com/nix-community/home-manager/commit/e9b9ecef4295a835ab073814f100498716b05a96
  xdg.configFile."gtk-4.0/gtk.css".text = lib.mkForce config.gtk.gtk4.extraCss;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      "clock-format" = "12h";
      "color-scheme" = "prefer-dark";
    };
  };

  # X11
  xresources.extraConfig =
    lib.mkIf (config.myFlake.home-manager.colorScheme == "tokyonight")
    (builtins.readFile "${pkgs.vimPlugins.tokyonight-nvim}/extras/xresources/tokyonight_night.Xresources");
}
