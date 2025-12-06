{ lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ../../profiles/sing-box-server
    ./hardware-configuration.nix
  ]
  ++ (./services |> lib.fileset.fileFilter (file: file.hasExt "nix") |> lib.fileset.toList);

  system.stateVersion = "25.11";
  networking.hostName = "tyo1";
  services.getty.autologinUser = "root";
}
