{
  system.stateVersion = "24.05";

  networking.firewall.allowedUDPPorts = [ 443 ];
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.caddy.enable = true;
  services.caddy.settings.apps.http.servers.srv0 = {
    listen = [ ":443" ];
  };
}
