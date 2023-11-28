{
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    ../../../../../nixos/flake-modules/sops-nix.nix
  ];

  ### sops-nix
  sops.secrets."clash-config" = {
    owner = config.users.users."clash-meta".name;
    group = config.users.groups."clash-meta".name;
    restartUnits = ["clash-meta.service"];
    path = "/etc/clash-meta/config.yaml";
  };

  ### System proxy settings
  networking.proxy.default = "http://127.0.0.1:7890/";

  ### User running proxy service
  users.groups."clash-meta" = {};
  users.users."clash-meta" = {
    isSystemUser = true;
    group = config.users.groups."clash-meta".name;
  };

  ### Proxy service
  systemd.services."clash-meta" = {
    description = "Clash.Meta Client";
    after = ["network-online.target"];

    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type = "simple";
      WorkingDirectory = "/etc/clash-meta";
      User = [config.users.users."clash-meta".name];
      Group = [config.users.groups."clash-meta".name];
      ExecStart = "${pkgs.clash-meta}/bin/clash-meta -d /etc/clash-meta";
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

  ### Local Clash WebUI
  # You can also use the following website, just in case:
  # - metacubexd:
  #   - GH Pages Custom Domain: http://d.metacubex.one
  #   - GH Pages: https://metacubex.github.io/metacubexd
  #   - Cloudflare Pages: https://metacubexd.pages.dev
  # - yacd (Yet Another Clash Dashboard):
  #   - https://yacd.haishan.me
  # - clash-dashboard (buggy):
  #   - https://clash.razord.top
  environment.etc."clash-meta/metacubexd".source = inputs.metacubexd;
}
