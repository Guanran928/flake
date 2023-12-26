{
  pkgs,
  config,
  inputs,
  ...
}: {
  services.clash = {
    enable = true;
    package = pkgs.clash-meta;
    configFile = config.sops.templates."clash.yaml".path;
    webui = inputs.self.packages.${pkgs.system}.metacubexd;
  };

  ### sops-nix
  sops.secrets = builtins.mapAttrs (_name: value: value // {restartUnits = ["clash.service"];}) {
    "clash/proxy-providers/efcloud" = {};
    "clash/proxy-providers/spcloud" = {};
    "clash/proxy-providers/pawdroid" = {};
  };

  # TODO: Using example config
  # https://wiki.metacubex.one/example/conf/
  # MetaCubeX/Meta-Docs doesnt look reliable through commit messages, no fetchers was used
  sops.templates."clash.yaml" = {
    owner = config.systemd.services."clash".serviceConfig.User;
    group = config.systemd.services."clash".serviceConfig.Group;
    content =
      builtins.readFile ./config.yaml
      + ''
        proxy-providers:
          efcloud:
            <<: *p
            url: "${config.sops.placeholder."clash/proxy-providers/efcloud"}"
          spcloud:
            <<: *p
            url: "${config.sops.placeholder."clash/proxy-providers/spcloud"}"
          #pawdroid:
          #  <<: *p
          #  url: "${config.sops.placeholder."clash/proxy-providers/pawdroid"}"
      '';
  };

  ### System proxy settings
  networking.proxy.default = "http://127.0.0.1:7890/";

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
}
