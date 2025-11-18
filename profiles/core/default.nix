{
  lib,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./networking.nix
    ./nix.nix
    ./zram.nix
  ]
  ++ (with inputs; [ sops-nix.nixosModules.sops ]);

  nixpkgs.config = {
    allowAliases = false;
    allowNonSource = false;

    allowNonSourcePredicate =
      pkg:
      lib.elem (lib.getName pkg) [
        # keep-sorted start
        "antlr"
        "cargo-bootstrap"
        "cef-binary"
        "dart"
        "go"
        "librusty_v8"
        "minecraft-server"
        "osu-lazer-bin"
        "rustc-bootstrap"
        "rustc-bootstrap-wrapper"
        "sof-firmware"
        "temurin-bin"
        "zen-twilight"
        # keep-sorted end
      ];

    allowUnfreePredicate =
      pkg:
      lib.elem (lib.getName pkg) [
        # keep-sorted start
        "fcitx5-pinyin-minecraft"
        "fcitx5-pinyin-moegirl"
        "osu-lazer-bin"
        "steam"
        "steam-unwrapped"
        # keep-sorted end
      ];

    permittedInsecurePackages = [ "olm-3.2.16" ];
  };

  boot.enableContainers = false;
  boot.initrd.systemd.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.etc.machine-id.text = "b08dfa6083e7567a1921a715000001fb"; # whonix id
  environment.systemPackages = with pkgs; [
    unzip
    tree
    file
    htop
    tmux

    lsof
    strace

    dnsutils
    pciutils
    usbutils
  ];

  environment.etc."tmux.conf".source = ./tmux.conf;

  users.mutableUsers = false;
  services.userborn.enable = true;
  environment.stub-ld.enable = false;

  programs.nano.enable = false;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # https://archlinux.org/news/making-dbus-broker-our-default-d-bus-daemon/
  services.dbus.implementation = "broker";

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  documentation = {
    doc.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  console = {
    earlySetup = true;
    keyMap = "dvorak";
  };

  # See `nixos-version(8)`
  system.configurationRevision = inputs.self.rev or "dirty";
}
