{...}: {
  imports = [
    ../default.nix
    ../../../../../flake-modules/lanzaboote.nix
    ../../../../../flake-modules/impermanence.nix
    ../../../../../flake-modules/disko.nix
  ];

  _module.args.disks = ["/dev/nvme0n1"]; # Disko
}
