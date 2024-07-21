{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.mihomo;
in {
  options.services.mihomo = {
    enable = lib.mkEnableOption "Whether to enable Mihomo, A rule-based proxy in Go.";
    package = lib.mkPackageOption pkgs "mihomo" {};
    webui = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = ''
        Local web interface to use.

        - metacubexd:
          - http://d.metacubex.one
          - https://metacubex.github.io/metacubexd
          - https://metacubexd.pages.dev
        - yacd:
          - https://yacd.haishan.me
        - clash-dashboard:
          - https://clash.razord.top
      '';
    };
    extraOpts = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
      description = "Extra command line options to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    ### launchd service
    # TODO: not run as root user
    launchd.daemons."mihomo" = {
      command = lib.concatStringsSep " " [
        (lib.getExe cfg.package)
        "-d /etc/mihomo"
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
