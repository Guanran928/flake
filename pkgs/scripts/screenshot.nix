{
  makeScript,
  coreutils,
  jq,
  grim,
  slurp,
  swappy,
  wl-clipboard,
  libnotify,
  fetchurl,
  substitute,
}:
makeScript {
  name = "screenshot";
  runtimeInputs = [coreutils jq grim slurp swappy wl-clipboard libnotify];
  file = substitute {
    src = fetchurl {
      url = "https://raw.githubusercontent.com/nwg-piotr/nwg-shell/c29e8eb4658a2613fb221ead0b101c75f457bcaf/scripts/screenshot";
      hash = "sha256-Z/fWloz8pLHsvPTPOeBxnbMsGDRTY3G3l/uePQ3ZxjU=";
    };

    # i dont like using an environment variable
    substitutions = [
      "--replace-warn"
      "DIR=\${SCREENSHOT_DIR:=$HOME/Screenshots}"
      "DIR=$HOME/Pictures/Screenshots"
    ];
  };
}
