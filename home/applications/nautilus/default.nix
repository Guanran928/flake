{pkgs, ...}: {
  home.packages = [pkgs.nautilus];
  dconf.settings = {
    "org/gnome/nautilus/list-view".default-zoom-level = "small";
    "org/gnome/nautilus/preferences".default-folder-viewer = "list-view";
    "org/gtk/gtk4/settings/file-chooser".show-hidden = true;
  };
}
