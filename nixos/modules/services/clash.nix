{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.clash;
in {
  options.services.clash = {
    enable = lib.mkEnableOption "Whether to enable Clash.";
    package = lib.mkPackageOption pkgs "clash" {};
  };

  config = lib.mkIf cfg.enable {
    ### User running clash
    users.groups."clash" = {};
    users.users."clash" = {
      isSystemUser = true;
      group = config.users.groups."clash".name;
    };

    ### systemd service
    systemd.services."clash" = {
      description = "Clash Daemon";
      after = ["network-online.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "simple";
        WorkingDirectory = "/etc/clash";
        User = [config.users.users."clash".name];
        Group = [config.users.groups."clash".name];
        ExecStart = "${lib.getExe cfg.package} -d /etc/clash";
        Restart = "on-failure";
        CapabilityBoundingSet = [
          "CAP_NET_ADMIN"
          "CAP_NET_BIND_SERVICE"
          "CAP_NET_RAW"
        ];
        AmbientCapabilities = [
          "CAP_NET_ADMIN"
          "CAP_NET_BIND_SERVICE"
          "CAP_NET_RAW"
        ];
      };
    };
  };
}
