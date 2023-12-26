{pkgs, ...}: {
  xdg.dataFile = {
    ### Local
    "backgrounds/unixcloud.jpg".source = ./wallpapers/unixcloud.jpg; # https://www.deviantart.com/georgegach/art/Unix-Cloud-818259008
    "backgrounds/Minato-Aqua.png".source = ./wallpapers/Minato-Aqua.png; # https://t.me/AnotherCreations/600
    "backgrounds/Minato-Aqua-Dark.png".source = ./wallpapers/Minato-Aqua-Dark.png; # https://t.me/AnotherCreations/602

    ### Online
    "backgrounds/aqua.png".source = pkgs.fetchurl {
      url = "https://github.com/mashumarodesu/dots/blob/master/Assets/Aqua.png?raw=true"; # https://www.pixiv.net/en/artworks/106654974
      hash = "sha256-JIat75RKz48a0BtniJBR1ifEk0tkkrHUrLPAHAz3Z1o=";
    };
    "backgrounds/summer.jpg".source = pkgs.fetchurl {
      url = "https://images.hdqwalls.com/wallpapers/anime-couple-on-bicycle-1u.jpg"; # https://www.pixiv.net/en/artworks/49983419
      hash = "sha256-J6ckWjfPyviUsDfswOYVPB4UEOBQ63Yr5yeJtOd9/2k=";
    };
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
