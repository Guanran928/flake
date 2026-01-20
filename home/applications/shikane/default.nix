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
          }
        ];
      }
      {
        name = "external";
        output = [
          {
            enable = true;
            search = [ "n=eDP-1" ];
            position = "560,1440";
          }
          {
            enable = true;
            search = [
              "m=P276MV"
              "s=0000000000000"
              "v=Beihai Century Joint Innovation Technology Co.,Ltd"
            ];
            mode = {
              width = 3840;
              height = 2160;
              refresh = 60; # FIXME: get a new cable
            };
            position = "0,0";
          }
        ];
      }
    ];
  };
}
