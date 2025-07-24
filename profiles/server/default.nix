{
  imports = [ ../prometheus ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMmd/uqiBahzKcKMJ+gT3dkUIdrWQgudspsDchDlx1E/ guanran928@outlook.com"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIGK/s8rGfSdz7nxot6IDP90eS7OAkmDGUtcQdttd76mRAAAABHNzaDo= guanran928@outlook.com"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIIbx1Dv5rBb1TJ62adWoxgo5eSeDooAw+puweQtx/zAnAAAABHNzaDo= guanran928@outlook.com"
  ];

  time.timeZone = "UTC";

  networking.domain = "ny4.dev";

  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    gnupg.sshKeyPaths = [ ];
  };
}
