{...}: {
  imports = [
    # utils that is used internally
    ./my/boot.nix
    ./my/hardware/audio.nix
    ./my/hardware/bluetooth.nix
    ./my/hardware/tpm.nix

    # nixpkgs styled options
    ./services/hysteria.nix
    ./services/pixivfe.nix
    ./services/rathole.nix
  ];
}
