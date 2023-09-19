{ ... }:

{
  security = {
    apparmor.enable = true;
    sudo.execWheelOnly = true;
  };

  boot.loader.systemd-boot.editor = false;

  services.openssh.settings = {
    PermitRootLogin = "no";
    PasswordAuthentication = false;
  };
}
