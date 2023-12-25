{...}: {
  imports = [
    # OS
    ../../profiles/core
    ../../profiles/device-type/laptop
    ../../profiles/opt-in/zram-generator.nix
    ../../profiles/opt-in/gaming.nix
    ../../profiles/opt-in/virt-manager.nix

    # User
    ../../../users/guanranwang/nixos/profiles/core
    ../../../users/guanranwang/nixos/profiles/device-type/laptop
    ../../../users/guanranwang/nixos/profiles/opt-in/clash-meta-client
    ../../../users/guanranwang/nixos/profiles/opt-in/gaming
    ../../../users/guanranwang/nixos/profiles/opt-in/torrenting

    # Hardware
    ./hardware-configuration.nix
    ../../profiles/opt-in/lanzaboote.nix
    ../../profiles/opt-in/impermanence.nix
    ../../profiles/opt-in/disko.nix
  ];

  networking.hostName = "Aristotle";
  time.timeZone = "Asia/Shanghai";
  _module.args.disks = ["/dev/nvme0n1"]; # Disko
}
