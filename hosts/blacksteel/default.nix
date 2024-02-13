{...}: {
  imports = [
    # OS
    ../../nixos/profiles/laptop
    ../../nixos/profiles/common/opt-in/zram-generator.nix
    ../../nixos/profiles/common/opt-in/clash-meta-client

    # Hardware
    ./hardware-configuration.nix
    ./anti-feature.nix
  ];

  networking.hostName = "blacksteel";
  time.timeZone = "Asia/Shanghai";

  # TODOs:
  # [x] networkmanager - > iwd
  # [ ] nouveau -> nvidia
  # [ ] secureboot (???)
  # [ ] impermanence
  # [ ] backlight is always 33% when booted up
  # [ ] fan is *blasting* even after I installed mbpfans
  # [ ] audio quality isnt too great (compared to macOS, or i might have wooden ears)
}
