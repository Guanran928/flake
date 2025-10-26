{
  boot.loader.grub.device = "/dev/vda";
  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "xen_blkfront"
    "vmw_pvscsi"
  ];
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
  };

  networking = {
    useNetworkd = true;
    useDHCP = false;
    usePredictableInterfaceNames = false;

    nameservers = [
      "178.239.124.254"
      "8.8.8.8"
      "2606:4700:47008.8.8.8111"
    ];

    defaultGateway = {
      address = "178.239.125.1";
      interface = "eth0";
    };

    defaultGateway6 = {
      address = "2602:fd6f:1f::1";
      interface = "eth0";
    };

    interfaces.eth0 = {
      ipv4 = {
        addresses = [
          {
            address = "178.239.125.6";
            prefixLength = 24;
          }
        ];
        routes = [
          {
            address = "178.239.125.1";
            prefixLength = 32;
          }
        ];
      };
      ipv6 = {
        addresses = [
          {
            address = "2602:fd6f:1f:3ed::324";
            prefixLength = 64;
          }
          {
            address = "fe80::be24:11ff:fe9a:8239";
            prefixLength = 64;
          }
        ];
        routes = [
          {
            address = "2602:fd6f:1f::1";
            prefixLength = 128;
          }
        ];
      };
    };
  };

  services.udev.extraRules = ''
    ATTR{address}=="bc:24:11:9a:82:39", NAME="eth0"
  '';
}
