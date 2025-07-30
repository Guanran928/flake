{ inputs, pkgs, ... }:
{
  imports = [
    ./hardening.nix
    ./networking.nix
    ./nix.nix
    ./zram.nix
  ]
  ++ (with inputs; [ sops-nix.nixosModules.sops ]);

  nixpkgs = {
    overlays = [ inputs.self.overlays.default ];
    config = {
      allowAliases = false;
      allowNonSource = false;
      allowUnfree = false;
    };
  };

  boot.enableContainers = false;
  boot.initrd.systemd.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "ia32_emulation=0" ];

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
  services.userborn.enable = true;
  environment.stub-ld.enable = false;

  programs.command-not-found.enable = false;
  programs.nano.enable = false;
  programs.neovim = {
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

  # See `nixos-version(8)`
  system.configurationRevision = inputs.self.rev or "dirty";
}
