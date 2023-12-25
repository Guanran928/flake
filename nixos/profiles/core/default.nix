{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardening
    ./nix
    ./packages

    # Flake modules
    inputs.self.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.sops-nix.nixosModules.sops
  ];

  users.mutableUsers = false;
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;}; # ??? isnt specialArgs imported by default ???
  };

  ### Boot
  boot.initrd.systemd.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot = {
    enable = lib.mkDefault true; # mkDefault for Lanzaboote
    editor = false; # Disabled for security
    ### Utilities
    #netbootxyz.enable = true;
    #memtest86.enable = true;
  };

  ### Default Programs
  environment.defaultPackages = [];
  # In addtion of https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/system-path.nix
  environment.systemPackages = with pkgs; [
    unzip
    wget
    tree
    file
    htop

    lsof
    ltrace

    dnsutils
    pciutils
    usbutils
  ];
  programs.dconf.enable = true;
  programs.nano.enable = false; # make sure to add another editor and set the $EDITOR variable
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };
  services.getty.greetingLine = let
    inherit (config.system) nixos;
  in ''
    NixOS ${nixos.label} ${nixos.codeName} (\m) - \l
    ${lib.strings.optionalString (builtins.elem "nvidia" config.services.xserver.videoDrivers)
      "--my-next-gpu-wont-be-nvidia"}
    ${lib.strings.optionalString (builtins.elem "amdgpu" config.boot.initrd.kernelModules)
      "[    5.996722] amdgpu 0000:67:00.0: Fatal error during GPU init"}
  '';

  hardware.nvidia.nvidiaSettings = false;
  ### WORKAROUND: Revert to NVIDIA version 470.223.02 due to performance issues in version 545.29.06,
  #               this shouldn't affect non-nvidia machines.
  nixpkgs.config.nvidia.acceptLicense = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;

  ### https://wiki.archlinux.org/title/Sysctl#Improving_performance
  boot.kernelModules = ["tcp_bbr"];
  boot.kernel.sysctl = {
    "net.ipv4.tcp_fastopen" = "3";

    "net.ipv4.tcp_keepalive_time" = "80";
    "net.ipv4.tcp_keepalive_intvl" = "10";
    "net.ipv4.tcp_keepalive_probes" = "6";
    "net.ipv4.tcp_mtu_probing" = "1";

    "net.core.default_qdisc" = "cake";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };
}
