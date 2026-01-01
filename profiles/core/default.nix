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
        "alsa-firmware"
        "antlr"
        "cargo-bootstrap"
        "cef-binary"
        "dart"
        "extism-js"
        "ghc-binary"
        "go"
        "librusty_v8"
        "linux-firmware"
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

    permittedInsecurePackages = [
      "olm-3.2.16" # mautrix-telegram
    ];
  };

  # keep-sorted start block=yes newline_separated=yes
  boot = {
    initrd.systemd.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  console = {
    earlySetup = true;
    keyMap = "dvorak";
  };

  documentation = {
    doc.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  environment.etc = {
    "machine-id".text = "b08dfa6083e7567a1921a715000001fb"; # whonix id
    "tmux.conf".source = ./tmux.conf;
  };

  environment.stub-ld = {
    enable = false;
  };

  environment.systemPackages = with pkgs; [
    # keep-sorted start
    dnsutils
    file
    htop
    lsof
    pciutils
    strace
    tmux
    tree
    unzip
    usbutils
    # keep-sorted end
  ];

  programs.nano = {
    enable = false;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  services = {
    dbus.implementation = "broker"; # https://archlinux.org/news/making-dbus-broker-our-default-d-bus-daemon/
    userborn.enable = true;
  };

  users = {
    mutableUsers = false;
  };
  # keep-sorted end

  # keep-sorted does not work with multiline strings
  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  # See `nixos-version(8)`
  system.configurationRevision = inputs.self.rev or "dirty";
}
