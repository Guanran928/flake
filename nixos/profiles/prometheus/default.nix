{ config, lib, ... }:

{
  services.prometheus.exporters.node = {
    enable = true;
    listenAddress = "127.0.0.1";
    port = 9091;
    enabledCollectors = [ "systemd" ];
  };
}
