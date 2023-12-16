{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.gnome.nautilus];
  xdg.configFile."gtk-3.0/bookmarks".text = ''
    file://${config.home.homeDirectory}/Documents/Projects/git-repos/github.com/Guanran928/flake
  '';
  dconf.settings = {
    "org/gnome/nautilus/list-view".default-zoom-level = "small";
    "org/gnome/nautilus/preferences".default-folder-viewer = "list-view";
    "org/gtk/gtk4/settings/file-chooser".show-hidden = true;
  };
}
