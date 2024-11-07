{
  services.resolved.enable = true;

  # FIXME: for some reason nslookup is not working
  networking.nameservers = [
    "223.5.5.5"
    "223.6.6.6"
  ];

  ### https://wiki.archlinux.org/title/Sysctl#Improving_performance
  boot.kernelModules = [ "tcp_bbr" ];
  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "cake";
    "net.ipv4.tcp_congestion_control" = "bbr";

    # https://github.com/quic-go/quic-go/wiki/UDP-Buffer-Sizes
    "net.core.rmem_max" = 7500000;
    "net.core.wmem_max" = 7500000;
  };
}
