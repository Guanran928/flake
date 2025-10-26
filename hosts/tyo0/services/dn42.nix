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
    address = "fd00:5d5b:797c::1";
    wgPrivkey = config.sops.secrets.wg-privatekey.path;
    lgPort = 4200;

    community = {
      region = 52; # Asia-E (JP,CN,KR,TW,HK)
      country = 1392; # Japan
    };

    peers =
      let
        last5 = x: builtins.substring ((builtins.stringLength x) - 5) 5 x;
      in
      [
        # iEdon, SIN
        rec {
          asn = "4242422189";
          address = "fd42:4242:2189:115::1";
          wireguard = {
            endpoint = "jp-ty2.dn42.iedon.net:57756";
            pubkey = "XjKsLfOYJ8y/U9saLpfM/MjXErlQ7gkw3+OgQTdVZ0U=";
            listenPort = last5 asn;
          };
        }
        # COWGL, TYO
        rec {
          asn = "4242423999";
          address = "fd36:62be:ef51:1::1";
          wireguard = {
            endpoint = "tyo.node.cowgl.xyz:30021";
            pubkey = "mMGGxtEqsagrx1Raw57C2H3Stl6ch/cUuF7y08eVgBE=";
            listenPort = last5 asn;
          };
        }
        # IYOROY, TYO
        rec {
          asn = "4242422024";
          address = "fd18:3e15:61d0::3";
          wireguard = {
            endpoint = "tyo-jp.ecs.iyoroy-infra.top:20021";
            pubkey = "Sh62ZCxnEcXyLq49mLP1jF4C2vWKhKMxjtZHxVUAQg4=";
            listenPort = last5 asn;
          };
        }
        # SUNNET, TYO
        rec {
          asn = "4242423088";
          address = "fdc8:dc88:ee11:190::1";
          wireguard = {
            endpoint = "tyo1-jp.dn42.6700.cc:20021";
            pubkey = "b3gUz8an2+wSCvXAwuxGR7AnxKDUqqQMd1+LASo93R0=";
            listenPort = last5 asn;
          };
        }
        # H503MC, HKG
        rec {
          asn = "4242420298";
          address = "fdfa:6ded:ae4:3000::1";
          wireguard = {
            endpoint = "node2.ox5.cc:20021";
            pubkey = "mkdYhqStqiT4tGQLCSZ0ByGNKY5T5/00I6OvAl1hpy0=";
            listenPort = last5 asn;
          };
        }
        # # BINGXIN, SIN
        # rec {
        #   asn = "4242423374";
        #   address = "fddf:3681:e80::227";
        #   wireguard = {
        #     endpoint = "sg01.dn42.baka.pub:20021";
        #     pubkey = "O3zvtZQNT6InSXgYDloIuQ4jP6PHO06WtsKz6coylBs=";
        #     listenPort = last5 asn;
        #   };
        # }
        # # LARE, TYO
        # rec {
        #   asn = "4242423035";
        #   address = "fd63:5d40:47e5::134";
        #   wireguard = {
        #     endpoint = "jp01.dn42.lare.cc:20021";
        #     pubkey = "oTPdRylNhX2O80e6rLejT9Fwzo7KWKZ7a3PUF4G9oEM=";
        #     listenPort = last5 asn;
        #   };
        # }
        # # NIGHTCOFFEE, TYO
        # rec {
        #   asn = "4242423508";
        #   address = "fd82:9700:355e:100::1";
        #   wireguard = {
        #     endpoint = "jp-tyo.dn42.ydkf.me:35603";
        #     pubkey = "gMlu6MvagM0Bvywjv0KXkqHX5JI3zY0rXx1c8Xt2zzc=";
        #     listenPort = last5 asn;
        #   };
        # }
        # # POTAT0, HKG
        # rec {
        #   asn = "4242421816";
        #   address = "fd2c:1323:4042::4";
        #   wireguard = {
        #     endpoint = "hkg.node.potat0.cc:20021";
        #     pubkey = "Tv1+HniELrS4Br2i7oQgwqBJFXQKculsW8r+UOqQXH0=";
        #     listenPort = last5 asn;
        #   };
        # }
        # # YINFENG, HKG
        # rec {
        #   asn = "4242420128";
        #   address = "fd72:db83:badd:6::1";
        #   wireguard = {
        #     endpoint = "[2404:8c80:85:1011:1:1:42cb:3d39]:20021";
        #     pubkey = "hZWqXT/9rDGvEgyoyzhbGCZItJD0MbWSfDVuDioSzUk=";
        #     listenPort = last5 asn;
        #   };
        # }
        # # Kioubit, HKG
        # rec {
        #   asn = "4242423914";
        #   address = "fdfc:e23f:fb45:3234::11";
        #   wireguard = {
        #     endpoint = "hk1.g-load.eu:20021";
        #     pubkey = "sLbzTRr2gfLFb24NPzDOpy8j09Y6zI+a7NkeVMdVSR8=";
        #     listenPort = last5 asn;
        #   };
        # }
      ];
  };
}
