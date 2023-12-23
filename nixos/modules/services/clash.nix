{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.clash;
in {
  options.services.clash = {
    enable = lib.mkEnableOption "Whether to enable Clash, A rule-based proxy in Go";
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
    # https://en.clash.wiki/introduction/service.html#systemd
    # https://wiki.metacubex.one/startup/service/#systemd
    systemd.services."clash" = {
      description = "Clash daemon, A rule-based proxy in Go.";
      after = ["network-online.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        # TODO: DynamicUser
        # DynamicUser = true;
        # LoadCredential = "credentials:${config.sops.secrets."clash-config".path}";

        # https://man.archlinux.org/man/systemd.exec.5
        ConfigurationDirectory = "clash";
        User = [config.users.users."clash".name];
        Group = [config.users.groups."clash".name];
        ExecStart = "${lib.getExe cfg.package} -d /etc/clash";

        # Capability, inherited from Clash wiki
        # https://man.archlinux.org/man/core/man-pages/capabilities.7.en
        CapabilityBoundingSet = ["CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" "CAP_NET_RAW"];
        AmbientCapabilities = ["CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" "CAP_NET_RAW"];
      };
    };
  };
}
