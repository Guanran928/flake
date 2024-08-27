{
  lib,
  inputs,
  pkgs,
  ...
}:
{
  imports =
    [
      ./hardening.nix
      ./networking.nix
      ./nix.nix
      ./zram.nix
    ]
    ++ (with inputs; [
      disko.nixosModules.disko
      home-manager.nixosModules.home-manager
      impermanence.nixosModules.impermanence
      lanzaboote.nixosModules.lanzaboote
      self.nixosModules.default
      sops-nix.nixosModules.sops
    ]);

  nixpkgs.overlays = [
    inputs.self.overlays.patches
  ];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [
    unzip
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

  users.mutableUsers = false;
  boot.initrd.systemd.enable = true;
  environment.stub-ld.enable = false;

  programs.command-not-found.enable = false;
  programs.nano.enable = false;
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  # https://archlinux.org/news/making-dbus-broker-our-default-d-bus-daemon/
  services.dbus.implementation = lib.mkDefault "broker";

  security.sudo.execWheelOnly = true;
  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  documentation = {
    doc.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  # https://github.com/NixOS/nixpkgs/pull/308801
  # nixos/switch-to-configuration: add new implementation
  system.switch = {
    enable = false;
    enableNg = true;
  };

  ### sops-nix
  sops = {
    defaultSopsFile = ../../../secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    gnupg.sshKeyPaths = [ ];
    secrets."hashed-passwd".neededForUsers = true;
  };
}
