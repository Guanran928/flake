{ lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ../../modules/dn42.nix
    ../../profiles/sing-box-server
    ./hardware-configuration.nix
  ]
  ++ (./services |> lib.fileset.fileFilter (file: file.hasExt "nix") |> lib.fileset.toList);

  _module.args.ports = import ./ports.nix;
  sops.defaultSopsFile = ./secrets.yaml;
  system.stateVersion = "25.11";

  networking.hostName = "tyo0";
  services.getty.autologinUser = "root";
}
