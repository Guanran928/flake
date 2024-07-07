{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # OS
    ../../nixos/profiles/laptop
    ../../nixos/profiles/common/opt-in/mihomo
    ../../nixos/profiles/common/opt-in/gaming

    # Hardware
    ./hardware-configuration.nix
    ./anti-feature.nix
    ../../nixos/profiles/common/opt-in/lanzaboote.nix
    ../../nixos/profiles/common/opt-in/impermanence.nix
    ../../nixos/profiles/common/opt-in/disko.nix
  ];

  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "aristotle";
  time.timeZone = "Asia/Shanghai";
  _module.args.disks = ["/dev/nvme0n1"]; # Disko
  system.stateVersion = "23.11";

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  # Stuff that I only want on my main machine
  home-manager.users.guanranwang = {
    imports = map (n: ../../home/applications/${n}) [
      "thunderbird"
      "ydict"
    ];

    home.packages =
      (with pkgs; [
        amberol
        fractal
        gnome-calculator
        hyperfine
        mousai
      ])
      ++ (with inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.scripts; [
        lofi
      ]);

    programs.obs-studio.enable = true;
  };

  # for udev rules
  programs.adb.enable = true;

  # fucking hell
  programs.anime-game-launcher.enable = true;

  # nouveou
  services.xserver.videoDrivers = [];

  # novideo
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  # environment.sessionVariables."MOZ_ENABLE_WAYLAND" = "0";
  # networking.networkmanager.enable = false;
  # services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # # https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/1562
  # services.udev.extraRules = ''
  #   ENV{DEVNAME}=="/dev/dri/card1", TAG+="mutter-device-preferred-primary"
  # '';
}
