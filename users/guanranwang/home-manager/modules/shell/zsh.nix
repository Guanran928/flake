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
        # should I use flake inputs / fetchurl?
        name = "sudo";
        src =
          pkgs.fetchFromGitHub {
            owner = "ohmyzsh";
            repo = "ohmyzsh";
            rev = "f8bf8f0029a475831ebfba0799975ede20e08742";
            hash = "sha256-9cJQQycahO+vo/YcAHjF+PVhsWxu7pa4MsK8Dgr69k0=";
            sparseCheckout = [
              "plugins/sudo"
            ];
          }
          + "/plugins/sudo";
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
