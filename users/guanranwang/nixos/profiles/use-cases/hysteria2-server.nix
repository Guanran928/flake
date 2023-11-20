{
  pkgs,
  config,
  ...
}: let
  etcDirectory = "hysteria";
  port = 43956;
in {
  imports = [
    ../../../../../../nixos/flake-modules/sops-nix.nix
  ];

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
    path = "/etc/${etcDirectory}/config.yaml";
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
      WorkingDirectory = "/etc/${etcDirectory}";
      User = [config.users.users."hysteria".name];
      Group = [config.users.groups."hysteria".name];
      ExecStart = "${pkgs.hysteria}/bin/hysteria server --config /etc/${etcDirectory}/config.yaml";
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
