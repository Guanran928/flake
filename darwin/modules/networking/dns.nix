{
  lib,
  config,
  ...
}: {
  options.myFlake.darwin.networking.dns = lib.mkOption {
    type = lib.types.enum ["google" "alidns"];
    default = "google";
    example = "alidns";
    description = "Select your DNS provider";
  };

  config.networking.dns = lib.mkMerge [
    (lib.mkIf (config.myFlake.darwin.networking.dns == "google") [
      ### Google DNS
      "8.8.8.8"
      "8.8.4.4"
      "2001:4860:4860::8888"
      "2001:4860:4860::8844"
    ])
    (lib.mkIf (config.myFlake.darwin.networking.dns == "alidns") [
      ### AliDNS
      "223.5.5.5"
      "223.6.6.6"
      "2400:3200::1"
      "2400:3200:baba::1"
    ])
  ];
}
