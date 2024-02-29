{pkgs, ...}: {
  imports = [
    # OS
    ../../nixos/profiles/laptop
    ../../nixos/profiles/common/opt-in/zram-generator.nix
    ../../nixos/profiles/common/opt-in/clash-meta-client
    ../../nixos/profiles/common/opt-in/gaming

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

  # Stuff that I only want on my main machine
  home-manager.users.guanranwang = {
    imports = map (n: ../../home/applications/${n}) [
      "spotify/spicetify.nix"
      "amberol"
      "mousai"
      "thunderbird"
      "telegram-desktop"
      "hyperfine"
      "ydict"
      "android-tools"
    ];

    home.packages = with pkgs; [
      fractal
      gnome.gnome-calculator
    ];

    programs.obs-studio.enable = true;
  };

  # for udev rules
  programs.adb.enable = true;
}
