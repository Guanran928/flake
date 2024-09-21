{ lib, ... }:
{
  sops.age.sshKeyPaths = lib.mkForce [ "/persist/etc/ssh/ssh_host_ed25519_key" ];

  preservation.enable = true;
  preservation.preserveAt."/persist" = {
    directories = [ "/var" ];
    files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };
}
