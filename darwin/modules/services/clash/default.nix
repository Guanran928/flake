{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.clash;
in {
  options.services.clash = {
    enable = lib.mkEnableOption "Whether to enable Clash, A rule-based proxy in Go.";
    package = lib.mkPackageOption pkgs "clash" {};
    configFile = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = "Configuration file to use.";
    };
    webui = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = ''
        Local web interface to use.

        You can also use the following website, just in case:
        - metacubexd:
          - http://d.metacubex.one
          - https://metacubex.github.io/metacubexd
          - https://metacubexd.pages.dev
        - yacd:
          - https://yacd.haishan.me
        - clash-dashboard (buggy):
          - https://clash.razord.top
      '';
    };
    extraOpts = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.string;
      description = "Extra command line options to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    ### launchd service
    # TODO: not run as root user
    launchd.daemons."clash" = {
      command = builtins.concatStringsSep " " [
        (lib.getExe cfg.package)
        "-d /etc/clash"
        (lib.optionalString (cfg.configFile != null) "-f ${cfg.configFile}")
        (lib.optionalString (cfg.webui != null) "-ext-ui ${cfg.webui}")
        (lib.optionalString (cfg.extraOpts != null) cfg.extraOpts)
      ];
      serviceConfig = {
        RunAtLoad = true;
        KeepAlive.NetworkState = true;
      };
    };
  };
}
