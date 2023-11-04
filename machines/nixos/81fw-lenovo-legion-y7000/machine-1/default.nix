{...}: {
  imports = [
    ../../../../flakes/nixos/lanzaboote.nix
    ../../../../flakes/nixos/impermanence.nix
    ../../../../flakes/nixos/disko.nix
  ];

  _module.args.disks = ["/dev/nvme0n1"]; # Disko
  boot.initrd.systemd.enable = true; # LUKS TPM unlocking
}
