{
  lib,
  config,
  ...
}: let
  cfg = config.myFlake.nixos.networking.dns;
in {
  options = {
    myFlake.nixos.networking.dns = {
      provider = lib.mkOption {
        type = lib.types.enum ["dhcp" "google" "alidns"];
        default =
          {
            "Asia/Shanghai" = "alidns";
          }
          .${config.time.timeZone}
          or "google";
        example = "alidns";
        description = "Select desired DNS provider.";
      };
    };
  };

  config = {
    networking.nameservers =
      {
        dhcp = [];
        google = [
          ### Google DNS
          "8.8.8.8"
          "8.8.4.4"
          "2001:4860:4860::8888"
          "2001:4860:4860::8844"
        ];
        alidns = [
          ### AliDNS
          "223.5.5.5"
          "223.6.6.6"
          "2400:3200::1"
          "2400:3200:baba::1"
        ];
      }
      .${cfg.provider};
  };
}
