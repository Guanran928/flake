{
  fetchurl,
  imagemagick,
  runCommandLocal,
}:
runCommandLocal "49983419_p0.jpg" {
  nativeBuildInputs = [imagemagick];

  # https://www.pixiv.net/en/artworks/49983419
  image = fetchurl {
    url = "https://i.pximg.net/img-original/img/2015/04/23/12/43/35/49983419_p0.jpg";
    hash = "sha256-JZ5VmsjVjZfHXpx3JxzAyYzZppZmgH38AiAA+B0TDiw=";
    curlOptsList = ["-e" "https://www.pixiv.net/"];
  };

  outputs = ["out" "dark"];
} ''
  magick $image -crop 3500x1600+0+100 $out
  magick $image \
    -crop 3500x1600+0+100 \
    -blur 8x8 \
    -brightness-contrast -10,0 \
    $dark
''
