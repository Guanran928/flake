{
  modulesPath,
  lib,
  config,
  ...
}: {
  imports = [
    "${modulesPath}/virtualisation/amazon-image.nix"
    ../../nixos/profiles/server
    ./anti-feature.nix
  ];

  time.timeZone = "Asia/Tokyo";
  boot.loader.grub.device = lib.mkForce "/dev/nvme0n1";
  system.stateVersion = "23.11";

  ### Services
  sops.secrets = builtins.mapAttrs (_name: value:
    value
    // {
      sopsFile = ./secrets.yaml;
      restartUnits = ["hysteria.service"];
    }) {
    "hysteria/certificate" = {};
    "hysteria/private-key" = {};
    "hysteria/auth" = {};
  };

  sops.templates."hysteria.yaml".content = ''
     tls:
       cert: /run/credentials/hysteria.service/cert
       key: /run/credentials/hysteria.service/key

     masquerade:
       type: proxy
       proxy:
         url: https://news.ycombinator.com/
         rewriteHost: true

    ${config.sops.placeholder."hysteria/auth"}
  '';

  networking.firewall.allowedUDPPorts = [80 443];
  networking.firewall.allowedTCPPorts = [80 443];

  services.hysteria = {
    enable = true;
    configFile = config.sops.templates."hysteria.yaml".path;
    credentials = [
      "cert:${config.sops.secrets."hysteria/certificate".path}"
      "key:${config.sops.secrets."hysteria/private-key".path}"
    ];
  };
}
