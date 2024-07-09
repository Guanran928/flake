{lib, ...}: {
  sops.secrets = builtins.mapAttrs (_name: value: value // {sopsFile = ./secrets.yaml;}) {
    "wireless/wangxiaobo".path = "/var/lib/iwd/wangxiaobo.psk";
    "wireless/OpenWrt".path = "/var/lib/iwd/OpenWrt.psk";
  };

  networking.wireless.iwd.enable = lib.mkDefault true;
}
