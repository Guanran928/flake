{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardening
    ./networking
    ./nix

    # Flake modules
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.nur.nixosModules.nur
    inputs.self.nixosModules.default
    inputs.sops-nix.nixosModules.sops
    inputs.nixos-sensible.nixosModules.default
  ];

  nixpkgs.overlays = [
    inputs.self.overlays.nautilus
    inputs.self.overlays.prismlauncher
    inputs.self.overlays.sway
  ];

  ### home-manager
  home-manager.users.guanranwang = import ../../../../home;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;}; # ??? isnt specialArgs imported by default ???
  };

  ### Boot
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = lib.mkDefault true; # mkDefault for Lanzaboote
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_zen; # mkDefault for server

  ### Default Programs
  # In addition of https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/system-path.nix
  environment.systemPackages = with pkgs; [
    unzip
    wget
    tree
    file
    htop

    lsof
    ltrace
    strace

    dnsutils
    pciutils
    usbutils
  ];

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

  users.users."guanranwang" = {
    isNormalUser = true;
    description = "Guanran Wang";
    extraGroups = [
      "wheel" # administrator
      "networkmanager" # access to networkmanager
      "tss" # access to tpm devices
      "vboxusers" # access to virtualbox
      "nix-access-tokens" # access to github tokens
      "libvirtd" # access to virt-manager
    ];
    hashedPasswordFile = config.sops.secrets."hashed-passwd".path;
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      # same as git signing
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMmd/uqiBahzKcKMJ+gT3dkUIdrWQgudspsDchDlx1E/ guanran928@outlook.com"
    ];
  };

  programs.dconf.enable = true;
  programs.fish.enable = true;
  users.groups."nix-access-tokens" = {};
  nix.extraOptions = "!include ${config.sops.secrets.nix-access-tokens.path}";

  ### sops-nix
  sops = {
    defaultSopsFile = ../../../../secrets.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    gnupg.sshKeyPaths = [];
    secrets = {
      "hashed-passwd" = {
        neededForUsers = true;
      };
      "nix-access-tokens" = {
        group = config.users.groups."nix-access-tokens".name;
        mode = "0440";
      };
    };
  };

  # xz backdoor killswitch
  # ref: https://gist.github.com/thesamesam/223949d5a074ebc3dce9ee78baad9e27?permalink_comment_id=5006861#gistcomment-5006861
  environment.sessionVariables."yolAbejyiejuvnup" = "Evjtgvsh5okmkAvj";
  systemd.services."sshd".environment."yolAbejyiejuvnup" = "Evjtgvsh5okmkAvj";
}
