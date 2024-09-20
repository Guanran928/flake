{ pkgs, ... }:
{
  imports = [ ../prometheus ];

  environment.systemPackages = with pkgs; [ foot.terminfo ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "prohibit-password";
    settings.PasswordAuthentication = false;
  };

  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMmd/uqiBahzKcKMJ+gT3dkUIdrWQgudspsDchDlx1E/ guanran928@outlook.com"
  ];

  time.timeZone = "UTC";

  networking.domain = "ny4.dev";
}
