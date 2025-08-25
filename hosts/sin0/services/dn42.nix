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
    address = "fd00:5d5b:797c::2";
    wgPrivkey = config.sops.secrets.wg-privatekey.path;
    lgPort = 4200;

    community = {
      region = 51; # Asia-SE (TH,SG,PH,ID,MY)
      country = 1702; # Singapore
    };

    peers =
      let
        last5 = x: builtins.substring ((builtins.stringLength x) - 5) 5 x;
      in
      [
        # iEdon, SIN
        rec {
          asn = "4242422189";
          address = "fd42:4242:2189:119::1";
          wireguard = {
            endpoint = "sg-sin.dn42.iedon.net:48054";
            pubkey = "XAmCHa9+dnC6uba+gFn5ucl7B69k8vmIAgJm3a8XlGQ=";
            listenPort = last5 asn;
          };
        }
        # Kioubit, HKG
        rec {
          asn = "4242423914";
          address = "fdfc:e23f:fb45:3234::11";
          wireguard = {
            endpoint = "hk1.g-load.eu:20021";
            pubkey = "sLbzTRr2gfLFb24NPzDOpy8j09Y6zI+a7NkeVMdVSR8=";
            listenPort = last5 asn;
          };
        }
      ];
  };
}
