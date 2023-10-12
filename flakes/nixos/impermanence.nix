{ inputs, ... }:

{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  # this folder is where the files will be stored (don't put it in tmpfs)
  environment.persistence."/nix/persist/system" = {
    directories = [
      # bind mounted from /nix/persist/system/etc/nixos to /etc/nixos
      #"/etc/NetworkManager/system-connections"
      "/etc/clash-meta" # clash-meta
      "/etc/secureboot" # sbctl, lanzaboote, etc
    ];
    files = [
      # NOTE: if you persist /var/log directory, you should persist /etc/machine-id as well
      # otherwise it will affect disk usage of log service
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };
}