{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = [ pkgs.waybar ];

  xdg.configFile."waybar/config.jsonc" = {
    source = ./config.jsonc;
    onChange = ''
      ${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true
    '';
  };

  xdg.configFile."waybar/style.css" = {
    source = ./style.css;
    onChange = ''
      ${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true
    '';
  };

  systemd.user.services.waybar = {
    Unit = {
      Description = "Highly customizable Wayland bar for Sway and Wlroots based compositors.";
      Documentation = "https://github.com/Alexays/Waybar/wiki";
      PartOf = [
        config.wayland.systemd.target
        "tray.target"
      ];
      After = [ config.wayland.systemd.target ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
      X-Restart-Triggers = [
        (toString config.xdg.configFile."waybar/config.jsonc".source)
        (toString config.xdg.configFile."waybar/style.css".source)
      ];
    };

    Service = {
      ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
      ExecStart = lib.getExe pkgs.waybar;
      KillMode = "mixed";
      Restart = "on-failure";
    };

    Install.WantedBy = [
      config.wayland.systemd.target
      "tray.target"
    ];
  };
}
