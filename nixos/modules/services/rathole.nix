{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.services.rathole;
in {
  options.services.rathole = {
    enable = lib.mkEnableOption "Rathole, a lightweight and high-performance reverse proxy for NAT traversal";

    package = lib.mkPackageOption pkgs "rathole" {};

    configFile = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = "Configuration file to use.";
    };

    credentials = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = lib.literalExpression ''
        [
          "cert:/tmp/certificate.crt"
          "key:/tmp/private-key.key"
        ];
      '';
      description = ''
        Extra credentials loaded by systemd, you can access them by `/run/credentials/rathole.service/foobar`.

        See `systemd.exec(5)` for more information.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.rathole = {
      description = "Rathole daemon, a lightweight and high-performance reverse proxy for NAT traversal.";
      wantedBy = ["multi-user.target"];
      after = ["network-online.target"];
      wants = ["network-online.target"];
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} $\{CREDENTIALS_DIRECTORY}/rathole.toml";
        LoadCredential = ["rathole.toml:${cfg.configFile}"] ++ cfg.credentials;
        DynamicUser = true;
      };
    };
  };
}
