{...}: {
  imports = [
    # utils that is used internally
    ./myFlake/boot.nix
    ./myFlake/hardware/accessories/logitech-wireless.nix
    ./myFlake/hardware/accessories/piper.nix
    ./myFlake/hardware/accessories/xbox-one-controller.nix
    ./myFlake/hardware/components/audio.nix
    ./myFlake/hardware/components/bluetooth.nix
    ./myFlake/hardware/components/tpm.nix

    # nixpkgs styled options
    ./services/hysteria.nix
  ];
}
