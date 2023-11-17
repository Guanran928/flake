{pkgs, ...}:
# Bluetooth
{
  # Bluetooth manager
  #services.blueman.enable = true;
  environment.systemPackages = with pkgs; [blueberry];

  # Bluetooth service
  hardware.bluetooth = {
    enable = true;
    settings.General.FastConnectable = true;
  };
}
