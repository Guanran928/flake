{pkgs, ...}: {
  services.mihomo = {
    enable = true;
    webui = pkgs.metacubexd;
  };

  ### System proxy settings
  networking.proxy.default = "http://127.0.0.1:7890/";
}
