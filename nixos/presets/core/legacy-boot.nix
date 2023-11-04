{ ... }:

{
  boot.loader = {
    grub.enable = true;
    grub.device = "/dev/vda"; # or "nodev" for efi only
    systemd-boot.enable = false;
  };
}
