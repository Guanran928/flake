{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    foot.terminfo
  ];

  # TODO: colmena
  services.openssh.settings.PermitRootLogin = "prohibit-password";
  users.users."root".openssh.authorizedKeys.keys = config.users.users.guanranwang.openssh.authorizedKeys.keys;

  time.timeZone = "UTC";
}
