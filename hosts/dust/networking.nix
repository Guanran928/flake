{ config, pkgs, ... }:
{
  sops.secrets = {
    "wireless/Galaxy S24 EC54" = { };
    "wireless/XYC-SEEWO" = { };
    "wireless/Svartalfheim" = { };
  };

  systemd.tmpfiles.settings."10-iwd" =
    let
      inherit (config.sops) secrets;
    in
    {
      "/var/lib/iwd/Svartalfheim.psk".C.argument = secrets."wireless/Svartalfheim".path;
      "/var/lib/iwd/XYC-SEEWO.psk".C.argument = secrets."wireless/XYC-SEEWO".path;
      "/var/lib/iwd/Galaxy S24 EC54.psk".C.argument = secrets."wireless/Galaxy S24 EC54".path;
    };

  networking = {
    useNetworkd = true;
    useDHCP = false;
  };

  systemd.network.networks = {
    "10-wlan0" = {
      name = "wlan0";
      DHCP = "yes";
      dhcpV4Config.RouteMetric = 2048;
      dhcpV6Config.RouteMetric = 2048;
    };
    "11-eth" = {
      matchConfig = {
        Kind = "!*";
        Type = "ether";
      };
      DHCP = "yes";
    };
  };

  services.sing-box.settings.experimental.clash_api = rec {
    external_controller = "127.0.0.1:9090";
    external_ui = pkgs.metacubexd;
    secret = "hunter2";
    # https://www.v2ex.com/t/1076579
    access_control_allow_origin = [ "http://${external_controller}" ];
  };
}
