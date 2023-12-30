{...}: {
  imports = [
    # OS
    ../../profiles/laptop
    ../../profiles/common/opt-in/zram-generator.nix
    ../../profiles/common/opt-in/gaming.nix
    ../../profiles/common/opt-in/virt-manager.nix

    # User
    ../../../users/guanranwang/nixos/profiles/laptop
    ../../../users/guanranwang/nixos/profiles/common/opt-in/clash-meta-client
    ../../../users/guanranwang/nixos/profiles/common/opt-in/gaming
    ../../../users/guanranwang/nixos/profiles/common/opt-in/torrenting

    # Hardware
    ./hardware-configuration.nix
    ../../profiles/common/opt-in/lanzaboote.nix
    ../../profiles/common/opt-in/impermanence.nix
    ../../profiles/common/opt-in/disko.nix
  ];

  networking.hostName = "Aristotle";
  time.timeZone = "Asia/Shanghai";
  _module.args.disks = ["/dev/nvme0n1"]; # Disko
}
