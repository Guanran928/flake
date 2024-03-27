{
  networking.wireless.iwd.enable = true;
  services.resolved.enable = true;

  sops.secrets."wireless/wangxiaobo".path = "/var/lib/iwd/wangxiaobo.psk";
  sops.secrets."wireless/OpenWrt".path = "/var/lib/iwd/OpenWrt.psk";

  ### https://wiki.archlinux.org/title/Sysctl#Improving_performance
  boot.kernelModules = ["tcp_bbr"];
  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "cake";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };
}
