{...}: {
  home.sessionPath = ["$HOME/.local/bin"];
  home.file.".local/bin" = {
    source = ./bin;
    recursive = true;
    executable = true;
  };
}
