{ config, ... }:
{
  home.packages = [ config.services.shikane.package ];

  services.shikane = {
    enable = true;
    settings.profile = [
      {
        name = "internal";
        output = [
          {
            enable = true;
            search = [ "n=eDP-1" ];
            scale = 1.75;
          }
        ];
      }
      {
        name = "external";
        output = [
          {
            enable = false;
            search = "eDP-1";
          }
          {
            enable = true;
            search = [
              "m=VG27AQML1A"
              "s=S7LMQS122018"
              "v=ASUSTek COMPUTER INC"
            ];
            mode = {
              width = 2560;
              height = 1440;
              refresh = 240.001;
            };
          }
        ];
      }
    ];
  };
}
