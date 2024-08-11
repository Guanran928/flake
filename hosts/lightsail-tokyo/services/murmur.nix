{
  # `journalctl -u murmur.service | grep Password`
  services.murmur = {
    enable = true;
    openFirewall = true;
    bandwidth = 256 * 1024; # 256 Kbit/s
  };
}
