{...}: {
  hardware = {
    enableRedistributableFirmware = true;
    #enableAllFirmware = true;
  };

  services = {
    #printing.enable = true; # Printing
    thermald.enable = true; # Prevents overheating
    fwupd.enable = true; # Firmware update
  };
}
