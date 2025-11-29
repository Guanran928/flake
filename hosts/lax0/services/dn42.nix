{ config, ... }:
{
  sops.secrets."wg-privatekey" = {
    owner = "systemd-network";
    restartUnits = [ "systemd-networkd.service" ];
  };

  networking.dn42 = {
    enable = true;
    asn = "4242420021";
    cidr = "fd00:5d5b:797c::/48";
    address = "fd00:5d5b:797c::3";
    wgPrivkey = config.sops.secrets.wg-privatekey.path;
    lgPort = 4200;

    community = {
      region = 44; # North America-W
      country = 1840; # United States of America
    };

    peers =
      let
        last5 = x: builtins.substring ((builtins.stringLength x) - 5) 5 x;
      in
      [
        # keep-sorted start block=yes
        # POTAT0, LAS
        rec {
          asn = "4242421816";
          address = "fd2c:1323:4042::3";
          wireguard = {
            endpoint = "las.node.potat0.cc:20021";
            pubkey = "LUwqKS6QrCPv510Pwt1eAIiHACYDsbMjrkrbGTJfviU=";
            listenPort = last5 asn;
          };
        }
        # Kioubit, LAX
        rec {
          asn = "4242423914";
          address = "fdfc:e23f:fb45:3234::9";
          wireguard = {
            endpoint = "us3.g-load.eu:20021";
            pubkey = "sLbzTRr2gfLFb24NPzDOpy8j09Y6zI+a7NkeVMdVSR8=";
            listenPort = last5 asn;
          };
        }
        # keep-sorted end
      ];
  };
}
