{ ... }:

{
  hardware = {
    # Enable redistriutable firmware
    enableRedistributableFirmware = true;

    # Enable all firmware
    #enableAllFirmware = true;
  };

  services = {
    #printing.enable = true; # Printing
    ratbagd.enable = true; # Required by piper
    thermald.enable = true; # Prevents overheating
    fwupd.enable = true; # Firmware update
  };
}