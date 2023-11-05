{config, ...}: {
  programs.bash = {
    enable = true;
    historyFile = "${config.xdg.configHome}/bash/.bash_history";
  };
}
