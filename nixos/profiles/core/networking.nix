{
  services.resolved.enable = true;

  ### https://wiki.archlinux.org/title/Sysctl#Improving_performance
  boot.kernelModules = [ "tcp_bbr" ];
  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "cake";
    "net.ipv4.tcp_congestion_control" = "bbr";

    # https://github.com/quic-go/quic-go/wiki/UDP-Buffer-Sizes
    "net.core.rmem_max" = 7500000;
    "net.core.wmem_max" = 7500000;
  };

  # Use nftables based firewall
  networking.nftables.enable = true;
}
