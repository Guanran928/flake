{...}: {
  # TODO: remove unnecessary scripts
  home.sessionPath = ["$HOME/.local/bin"];
  home.file = {
    ".local/bin" = {
      source = ../../../dotfiles/bin;
      recursive = true;
    };
  };
}
