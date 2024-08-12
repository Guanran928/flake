{
  pkgs,
  config,
  ...
}: {
  services.pixivfe = {
    enable = true;
    EnvironmentFile = config.sops.secrets."pixivfe/environment".path;
    settings = {
      PIXIVFE_UNIXSOCKET = "/run/pixivfe/pixiv.sock";
      PIXIVFE_IMAGEPROXY = "https://i.pixiv.re";
    };
  };

  systemd.services.pixivfe.serviceConfig = {
    RuntimeDirectory = ["pixivfe"];
    ExecStartPost = pkgs.writeShellScript "pixivfe-unixsocket" ''
      ${pkgs.coreutils}/bin/sleep 5
      ${pkgs.coreutils}/bin/chmod 777 /run/pixivfe/pixiv.sock
    '';
  };
}
