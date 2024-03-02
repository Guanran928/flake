{
  makeScript,
  coreutils,
  mpv,
  fetchurl,
}:
makeScript {
  name = "lofi";
  runtimeInputs = [coreutils mpv];
  file = fetchurl {
    url = "https://raw.githubusercontent.com/lime-desu/bin/69422c37582c5914863997c75c268791a0de136e/lofi";
    hash = "sha256-hT+S/rqOHUYnnFcSDFfQht4l1DGasz1L3wDHKUWLraA=";
  };
}
