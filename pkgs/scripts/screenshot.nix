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
}:
makeScript {
  name = "screenshot";
  runtimeInputs = [coreutils jq grim slurp swappy wl-clipboard libnotify];
  src = fetchurl {
    url = "https://raw.githubusercontent.com/nwg-piotr/nwg-shell/c29e8eb4658a2613fb221ead0b101c75f457bcaf/scripts/screenshot";
    hash = "sha256-w0zdCX6az0WNM0G4RrNuKbQ0O9aSIK6ssAMMaFlsjA0=";
    postFetch = ''
      substituteInPlace $out \
        --replace-fail 'DIR=''${SCREENSHOT_DIR:=$HOME/Screenshots}' 'DIR=$HOME/Pictures/Screenshots'
    '';
  };
}
