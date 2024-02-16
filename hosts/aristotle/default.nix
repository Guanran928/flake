{...}: {
  imports = [
    # OS
    ../../nixos/profiles/laptop
    ../../nixos/profiles/common/opt-in/zram-generator.nix
    ../../nixos/profiles/common/opt-in/clash-meta-client
    ../../nixos/profiles/common/opt-in/gaming
    ../../nixos/profiles/common/opt-in/torrenting

    # Hardware
    ./hardware-configuration.nix
    ./anti-feature.nix
    ../../nixos/profiles/common/opt-in/lanzaboote.nix
    ../../nixos/profiles/common/opt-in/impermanence.nix
    ../../nixos/profiles/common/opt-in/disko.nix
  ];

  networking.hostName = "aristotle";
  time.timeZone = "Asia/Shanghai";
  _module.args.disks = ["/dev/nvme0n1"]; # Disko

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
}
