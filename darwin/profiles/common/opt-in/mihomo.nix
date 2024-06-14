{
  pkgs,
  config,
  ...
}: {
  services.clash = {
    enable = true;
    package = pkgs.clash-meta;
    webui = config.nur.repos.guanran928.metacubexd;
  };

  ### System proxy settings
  networking.proxy.default = "http://127.0.0.1:7890/";
}
