{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    initExtra = "zstyle ':fzf-tab:*' fzf-command sk";

    enableAutosuggestions = true;
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;
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

    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      save = 1000000;
      size = 1000000;
    };
  };
}
