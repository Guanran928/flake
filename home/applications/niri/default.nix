{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    niri
    xwayland-satellite
  ];

  xdg.configFile."niri/config.kdl".source = ./config.kdl;

  systemd.user.services.swaybg = {
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Unit = {
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.swaybg} -i ${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src} -m fill";
      Restart = "on-failure";
    };
  };
}
