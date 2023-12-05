{pkgs, ...}: let
  binPATH = ".local/bin";
in {
  home.sessionPath = ["$HOME/${binPATH}"];
  home.file = {
    ${binPATH} = {
      source = ./bin;
      recursive = true;
      executable = true;
    };
    "${binPATH}/lofi" = {
      source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/lime-desu/bin/main/lofi";
        hash = "sha256-hT+S/rqOHUYnnFcSDFfQht4l1DGasz1L3wDHKUWLraA=";
      };
      executable = true;
    };
    "${binPATH}/screenshot" = {
      source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/nwg-piotr/nwg-shell/c29e8eb4658a2613fb221ead0b101c75f457bcaf/scripts/screenshot";
        hash = "sha256-Z/fWloz8pLHsvPTPOeBxnbMsGDRTY3G3l/uePQ3ZxjU=";
      };
      executable = true;
    };
  };
}
