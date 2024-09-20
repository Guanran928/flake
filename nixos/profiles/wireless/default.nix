{ lib, ... }:
{
  sops.secrets = lib.listToAttrs (
    lib.map
      (
        x:
        lib.nameValuePair "wireless/${x}" {
          path = "/var/lib/iwd/${x}.psk";
          sopsFile = ./secrets.yaml;
        }
      )
      [
        "Galaxy S24 EC54"
        "ImmortalWrt"
        "XYC-SEEWO"
        "wangxiaobo"
      ]
  );

  networking.wireless.iwd.enable = true;
}
