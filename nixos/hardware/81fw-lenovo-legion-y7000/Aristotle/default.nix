{...}: {
  imports = [
    ../default.nix
    ../../../../nixos/flake-modules/lanzaboote.nix
    ../../../../nixos/flake-modules/impermanence.nix
    ../../../../nixos/flake-modules/disko.nix
  ];

  _module.args.disks = ["/dev/nvme0n1"]; # Disko
  boot.initrd.systemd.enable = true; # LUKS TPM unlocking
}
