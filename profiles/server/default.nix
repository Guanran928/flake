{ lib, ... }:
{
  imports = [ ./prometheus.nix ];

  # keep-sorted start block=yes newline_separated=yes
  boot.kernelParams = [ "ia32_emulation=0" ];

  services.caddy.settings.apps.tls.automation.policies = lib.singleton {
    disable_ocsp_stapling = true;
    issuers = lib.singleton {
      module = "acme";
      profile = "shortlived";
    };
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    gnupg.sshKeyPaths = [ ];
  };

  time.timeZone = "UTC";

  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMmd/uqiBahzKcKMJ+gT3dkUIdrWQgudspsDchDlx1E/ guanran928@outlook.com"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIGK/s8rGfSdz7nxot6IDP90eS7OAkmDGUtcQdttd76mRAAAABHNzaDo= guanran928@outlook.com"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIIbx1Dv5rBb1TJ62adWoxgo5eSeDooAw+puweQtx/zAnAAAABHNzaDo= guanran928@outlook.com"
  ];
  # keep-sorted end
}
