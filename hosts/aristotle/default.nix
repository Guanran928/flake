{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # OS
    ../../nixos/profiles/laptop
    ../../nixos/profiles/common/opt-in/clash-meta-client
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
      "spotify/spicetify.nix"
      "thunderbird"
      "ydict"
    ];

    home.packages = with pkgs;
      [
        amberol
        fractal
        gnome.gnome-calculator
        hyperfine
        mousai
      ]
      ++ (with inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.scripts; [
        lofi
      ]);

    programs.obs-studio.enable = true;
  };

  # for udev rules
  programs.adb.enable = true;

  # fucking hell
  programs.anime-game-launcher.enable = true;
}
