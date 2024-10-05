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
            criteria = "ASUSTek COMPUTER INC VG27AQML1A S5LMQS059959";
            mode = "2560x1440@119.998";
            status = "enable";
          }
        ];
      }
    ];
  };
}
