{
  pkgs,
  config,
  ...
}: let
  port = 43956;
in {
  ### Firewall
  networking.firewall = {
    allowedTCPPorts = [port 80 443];
    allowedUDPPorts = [port 80 443];
  };

  #### sops-nix
  sops.secrets."hysteria-config" = {
    owner = config.users.users."hysteria".name;
    group = config.users.groups."hysteria".name;
    restartUnits = ["hysteria-server.service"];
    path = "/etc/hysteria/config.yaml";
  };

  ### User running proxy service
  users.groups."hysteria" = {};
  users.users."hysteria" = {
    isSystemUser = true;
    group = config.users.groups."hysteria".name;
  };

  ### Proxy service
  systemd.services."hysteria-server" = {
    description = "Hysteria Server";
    after = ["network.target"];

    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type = "simple";
      WorkingDirectory = "/etc/hysteria";
      User = [config.users.users."hysteria".name];
      Group = [config.users.groups."hysteria".name];
      ExecStart = "${pkgs.hysteria}/bin/hysteria server --config /etc/hysteria/config.yaml";
      Restart = "on-failure";
      CapabilityBoundingSet = [
        "CAP_NET_ADMIN"
        "CAP_NET_BIND_SERVICE"
        "CAP_NET_RAW"
      ];
      AmbientCapabilities = [
        "CAP_NET_ADMIN"
        "CAP_NET_BIND_SERVICE"
        "CAP_NET_RAW"
      ];
    };
  };
}
