{
  pkgs,
  config,
  inputs,
  ...
}: {
  services.clash = {
    enable = true;
    package = pkgs.clash-meta;
    configFile = config.sops.secrets."clash-config".path;
    webui = inputs.self.packages.${pkgs.system}.metacubexd;
  };

  ### sops-nix
  sops.secrets."clash-config" = {
    owner = config.users.users."clash".name;
    group = config.users.groups."clash".name;
    restartUnits = ["clash.service"];
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
