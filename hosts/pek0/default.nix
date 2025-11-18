{
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    # OS
    ../../profiles/sing-box

    # Hardware
    ./hardware-configuration.nix

    # Services
    # keep-sorted start
    ./services/cloudflared.nix
    ./services/forgejo.nix
    ./services/immich.nix
    ./services/mastodon.nix
    ./services/matrix.nix
    ./services/mautrix.nix
    ./services/minecraft.nix
    ./services/miniflux.nix
    ./services/pocket-id.nix
    ./services/postgresql.nix
    ./services/prometheus.nix
    ./services/rustical.nix
    ./services/samba.nix
    ./services/transmission.nix
    ./services/vaultwarden.nix
    ./services/wastebin.nix
    # keep-sorted end
  ]
  ++ (with inputs; [ nix-minecraft.nixosModules.minecraft-servers ]);

  _module.args.ports = import ./ports.nix;
  sops.defaultSopsFile = ./secrets.yaml;
  networking.hostName = "pek0";
  system.stateVersion = "25.05";

  # FIXME: dotnet
  nixpkgs.config.allowNonSourcePredicate = lib.mkForce (_pkg: true);

  # Password protected physical TTY access
  sops.secrets."hashed-passwd".neededForUsers = true;
  users.users."root".hashedPasswordFile = config.sops.secrets."hashed-passwd".path;
  boot.kernelParams = [ "consoleblank=60" ];

  networking = {
    useNetworkd = true;
    useDHCP = false;
  };

  systemd.network.networks.ethernet = {
    matchConfig.Name = [
      "en*"
      "eth*"
    ];
    DHCP = "yes";
  };

  services.tailscale = {
    enable = true;
    extraDaemonFlags = [ "--no-logs-no-support" ];
  };

  systemd.services.caddy.serviceConfig.SupplementaryGroups = [ config.users.groups.anubis.name ];

  services.caddy.enable = true;
  services.caddy.settings.apps.http.servers.srv0 = {
    listen = [ ":80" ];
    trusted_proxies = {
      ranges = [
        "192.168.0.0/16"
        "172.16.0.0/12"
        "10.0.0.0/8"
        "127.0.0.1/8"
        "fd00::/8"
        "::1"
      ];
      source = "static";
    };
    trusted_proxies_strict = 1;
  };
}
