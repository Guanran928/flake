{
  programs.tmux = {
    enable = true;

    # value from tmux-sensible, but got overridden by HM (?)
    aggressiveResize = true;
    escapeTime = 0;
    historyLimit = 50000;

    baseIndex = 1;
    customPaneNavigationAndResize = true;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    terminal = "tmux-256color";
    extraConfig = ''
      set -g set-clipboard on
      set -g renumber-windows on
    '';
  };
}
