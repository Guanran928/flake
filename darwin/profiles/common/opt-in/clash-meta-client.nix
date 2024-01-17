{
  inputs,
  pkgs,
  ...
}: {
  services.clash = {
    enable = true;
    package = pkgs.clash-meta;
    webui = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.metacubexd;
  };

  ### System proxy settings
  networking.proxy.default = "http://127.0.0.1:7890/";
}
