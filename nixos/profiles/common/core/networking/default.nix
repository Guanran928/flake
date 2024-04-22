{
  lib,
  config,
  ...
}: {
  networking.wireless.iwd.enable = lib.mkDefault true;
  services.resolved.enable = true;

  sops.secrets."wireless/wangxiaobo".path = lib.mkIf config.networking.wireless.iwd.enable "/var/lib/iwd/wangxiaobo.psk";
  sops.secrets."wireless/OpenWrt".path = lib.mkIf config.networking.wireless.iwd.enable "/var/lib/iwd/OpenWrt.psk";

  ### https://wiki.archlinux.org/title/Sysctl#Improving_performance
  boot.kernelModules = ["tcp_bbr"];
  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "cake";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };
}
