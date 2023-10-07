{ ... }:

{
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/67E3-17ED";
      fsType = "vfat";
    };

    "/" = {
      device = "/dev/disk/by-uuid/571588f1-dc9c-4804-a89c-995a667e0574";
      fsType = "ext4";
    };
  };

  swapDevices = [ ];
}