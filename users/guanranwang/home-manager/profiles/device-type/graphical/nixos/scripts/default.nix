{pkgs, ...}: {
  home.sessionPath = ["$HOME/.local/bin"];
  home.file = {
    ".local/bin" = {
      source = ./bin;
      recursive = true;
      executable = true;
    };
    ".local/bin/lofi" = {
      source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/lime-desu/bin/main/lofi";
        hash = "sha256-hT+S/rqOHUYnnFcSDFfQht4l1DGasz1L3wDHKUWLraA=";
      };
      executable = true;
    };
  };
}
