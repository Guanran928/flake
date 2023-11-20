{
  pkgs,
  config,
  ...
}: let
  etcDirectory = "juicity";
  port = "33829";
in {
  imports = [
    ../../../../../../nixos/flake-modules/sops-nix.nix
  ];

  ### Firewall
  networking.firewall = {
    allowedTCPPorts = [port];
    allowedUDPPorts = [port];
  };

  #### sops-nix
  sops.secrets."juicity-config" = {
    owner = config.users.users."juicity".name;
    group = config.users.groups."juicity".name;
    restartUnits = ["juicity-server.service"];
    path = "/etc/${etcDirectory}/config.yaml";
  };

  ### User running proxy service
  users.groups."juicity" = {};
  users.users."juicity" = {
    isSystemUser = true;
    group = config.users.groups."juicity".name;
  };

  ### Proxy service
  systemd.services."juicity-server" = {
    description = "Juicity Server";
    after = ["network.target"];

    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type = "simple";
      WorkingDirectory = "/etc/${etcDirectory}";
      User = [config.users.users."juicity".name];
      Group = [config.users.groups."juicity".name];
      ExecStart = "${pkgs.juicity}/bin/juicity-server run -c /etc/${etcDirectory}/config.json";
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
