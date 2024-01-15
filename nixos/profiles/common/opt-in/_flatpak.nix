{
  services.flatpak.enable = true;
  services.gnome.core-utilities.enable = false; # remove default gnome pkgs, for example, gnome-music, to use flatpaks instead

  # HACKs:
  # Flatpak portal bug
  # https://github.com/NixOS/nixpkgs/issues/189851#issuecomment-1238907955
  systemd.user.extraConfig = "DefaultEnvironment='PATH=/run/current-system/sw/bin'";

  # Flatpak icons / fonts
  # https://github.com/NixOS/nixpkgs/issues/119433#issuecomment-1326957279
  # No longer works, for some reason
  #system.fsPackages = with pkgs; [ bindfs ];
  #fileSystems = let
  #  mkRoSymBind = path: {
  #    device = path;
  #    fsType = "fuse.bindfs";
  #    options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
  #  };
  #  aggregatedIcons = pkgs.buildEnv {
  #    name = "system-icons";
  #    paths = config.environment.systemPackages;
  #    pathsToLink = [ "/share/icons" ];
  #  };
  #  aggregatedFonts = pkgs.buildEnv {
  #    name = "system-fonts";
  #    paths = config.fonts.packages;
  #    pathsToLink = [ "/share/fonts" ];
  #  };
  #in {
  #  # Create an FHS mount to support flatpak host icons/fonts
  #  #"/usr/share/icons" = mkRoSymBind (aggregatedIcons + "/share/icons");
  #  "/usr/share/icons" = mkRoSymBind (/run/current-system/sw/share/icons);
  #  "/usr/share/fonts" = mkRoSymBind (aggregatedFonts + "/share/fonts");
  #};
}
