{ inputs, pkgs, ... }:
{
  imports =
    [
      ./hardening.nix
      ./networking.nix
      ./nix.nix
      ./zram.nix
    ]
    ++ (with inputs; [
      self.nixosModules.default
      sops-nix.nixosModules.sops
    ]);

  nixpkgs.overlays = [ inputs.self.overlays.default ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

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
  services.dbus.implementation = "broker";

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

  # See `nixos-version(8)`
  system.configurationRevision = inputs.self.rev or "dirty";
}
