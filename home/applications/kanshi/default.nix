{
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile.name = "internal";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            scale = 1.75;
          }
        ];
      }
      {
        profile.name = "external";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "ASUSTek COMPUTER INC VG27AQML1A S7LMQS122018";
            mode = "2560x1440@240.001";
            status = "enable";
          }
        ];
      }
    ];
  };
}
