{ pkgs, ... }:

{
  services = {
    # GNOME applications
    gvfs.enable = true; # nautilus
    gnome = {
      sushi.enable = true; # nautilus preview
      gnome-online-accounts.enable = true;
    };
  };

  programs = {
    gnome-disks.enable = true;
    kdeconnect = {
      enable = true;
      #package = pkgs.gnomeExtensions.gsconnect;
      package = pkgs.valent;
    };
  };
}
