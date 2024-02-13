{
  lib,
  pkgs,
  ...
}: let
  # curlOpts for pixiv, or it returns 403.
  curlOptsList = ["-e" "https://www.pixiv.net/"];
in {
  xdg.dataFile = {
    ### Local
    "backgrounds/unixcloud.jpg".source = ./wallpapers/unixcloud.jpg; # https://www.deviantart.com/georgegach/art/Unix-Cloud-818259008
    "backgrounds/Minato-Aqua.png".source = ./wallpapers/Minato-Aqua.png; # https://t.me/AnotherCreations/600
    "backgrounds/Minato-Aqua-Dark.png".source = ./wallpapers/Minato-Aqua-Dark.png; # https://t.me/AnotherCreations/602

    ### Online
    "backgrounds/aqua.png".source = pkgs.fetchurl {
      inherit curlOptsList;
      url = "https://i.pximg.net/img-original/img/2023/03/29/01/29/52/106654974_p0.jpg"; # https://www.pixiv.net/en/artworks/106654974
      hash = "sha256-mB/D46JCddOlMUtFQu7R0OtRMIoApbT1nnRv0VyzEb8=";
    };
    "backgrounds/summer.jpg".source = let
      image = pkgs.fetchurl {
        inherit curlOptsList;
        url = "https://i.pximg.net/img-original/img/2015/04/23/12/43/35/49983419_p0.jpg"; # https://www.pixiv.net/en/artworks/49983419
        hash = "sha256-JZ5VmsjVjZfHXpx3JxzAyYzZppZmgH38AiAA+B0TDiw=";
      };
    in
      # Crop 100px on top and bottom
      pkgs.runCommandNoCC "49983419_p0.jpg" {} ''
        ${lib.getExe pkgs.imagemagick} convert ${image} -crop 3500x1600+0+100 $out
      '';
    "backgrounds/macos-mojave-day.jpg".source = pkgs.fetchurl {
      url = "https://media.idownloadblog.com/wp-content/uploads/2018/06/macOS-Mojave-Day-wallpaper.jpg";
      hash = "sha256-DtIaO7jWkhdU4EqJL8QfAaaajRcME79/O8szk1po/Go=";
    };
    "backgrounds/macos-mojave-night.jpg".source = pkgs.fetchurl {
      url = "https://media.idownloadblog.com/wp-content/uploads/2018/06/macOS-Mojave-Night-wallpaper.jpg";
      hash = "sha256-Zv7uvjSNACpI2Yck22bsA8gwVaju2Yght7y09xko9xw=";
    };
  };
}
