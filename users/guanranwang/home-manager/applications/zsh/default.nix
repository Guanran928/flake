{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    ### XDG
    dotDir = ".config/zsh";
    ### Plugins
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    enableAutosuggestions = true;
    plugins = [
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
      {
        name = "sudo";
        src = "${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/sudo";
      }
    ];
    initExtra = "zstyle ':fzf-tab:*' fzf-command sk";
    ### History
    history = {
      path = "${config.xdg.configHome}/zsh/.zsh_history";
      save = 1000000;
      size = 1000000;
    };
  };
}
