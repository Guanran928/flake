{
  networking.wireless.iwd.enable = true;
  networking.nameservers = [
    ### AliDNS
    "223.5.5.5"
    "223.6.6.6"
    "2400:3200::1"
    "2400:3200:baba::1"
  ];

  ### systemd-resolved
  services.resolved = {
    enable = true;
    domains = ["~."];
    dnssec = "true";
    extraConfig = "DNSOverTLS=yes";
    fallbackDns = [
      #"8.8.8.8#dns.google"
      #"8.8.4.4#dns.google"
      #"2001:4860:4860::8888#dns.google"
      #"2001:4860:4860::8844#dns.google"
    ];
  };

  ### https://wiki.archlinux.org/title/Sysctl#Improving_performance
  boot.kernelModules = ["tcp_bbr"];
  boot.kernel.sysctl = {
    "net.ipv4.tcp_fastopen" = "3";

    "net.ipv4.tcp_keepalive_time" = "80";
    "net.ipv4.tcp_keepalive_intvl" = "10";
    "net.ipv4.tcp_keepalive_probes" = "6";
    "net.ipv4.tcp_mtu_probing" = "1";

    "net.core.default_qdisc" = "cake";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };
}
