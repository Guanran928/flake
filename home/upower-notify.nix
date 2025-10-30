{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  systemd.user.services.upower-notify = {
    Unit = {
      Description = "Simple program to send notifications on battery status changes";
      PartOf = [ config.wayland.systemd.target ];
      After = [ config.wayland.systemd.target ];
    };

    Service = {
      Type = "simple";
      ExecStart = lib.getExe inputs.upower-notify.packages.${pkgs.stdenv.hostPlatform.system}.default;
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ config.wayland.systemd.target ];
    };
  };
}
