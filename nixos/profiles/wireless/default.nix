{ lib, ... }:
{
  sops.secrets = lib.mapAttrs (_name: value: value // { sopsFile = ./secrets.yaml; }) {
    "wireless/wangxiaobo".path = "/var/lib/iwd/wangxiaobo.psk";
    "wireless/ImmortalWrt".path = "/var/lib/iwd/ImmortalWrt.psk";
  };

  networking.wireless.iwd.enable = lib.mkDefault true;
}
