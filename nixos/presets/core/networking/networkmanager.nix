{...}: {
  networking = {
    networkmanager = {
      enable = true;
      ethernet.macAddress = "random";
      wifi.macAddress = "random";
    };
    wireless.iwd.enable = false;
  };
}
