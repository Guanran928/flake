{ pkgs, ... }:

{
  boot.plymouth.enable = true;
  security.polkit.enable = true;
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
      package = pkgs.gnomeExtensions.gsconnect;
    };
    gamemode = {
      enable = true;
      settings.custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode Activated' 'GameMode Activated! Enjoy enhanced performance. 🚀'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode Deactivated' 'GameMode Deactivated. Back to normal mode. ⏹️'";
      };
    };
    clash-verge = {
      #enable = true;
      autoStart = true; # not working at all, edit: works on gnome
      tunMode = true;
    };
  };
}