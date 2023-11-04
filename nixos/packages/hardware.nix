{...}: {
  hardware = {
    enableRedistributableFirmware = true;
    #enableAllFirmware = true;
  };

  services = {
    #printing.enable = true; # Printing
    ratbagd.enable = true; # Required by piper
    thermald.enable = true; # Prevents overheating
    fwupd.enable = true; # Firmware update
  };
}
