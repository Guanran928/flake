{...}: {
  imports = [
    ../../../../applications/git
    ../../../../applications/starship
    ../../../../applications/eza
    ../../../../applications/skim
    ../../../../applications/bat
    ../../../../applications/bottom
    ../../../../applications/zoxide
    ../../../../applications/ripgrep
    ../../../../applications/wget
    ../../../../applications/fd
    ../../../../applications/hyperfine

    ../../../../applications/ydict
    ../../../../applications/fastfetch
    ../../../../applications/android-tools
    ../../../../applications/tealdeer
  ];

  home.shellAliases = {
    ".." = "cd ..";
    "farsee" = "curl -F 'c=@-' 'https://fars.ee/'"; # pb

    # proxy
    "setproxy" = let
      proxy = "http://127.0.0.1:7890/";
    in "export http_proxy=${proxy} https_proxy=${proxy} ftp_proxy=${proxy} rsync_proxy=${proxy}";
    "unsetproxy" = "set -e http_proxy https_proxy all_proxy";
  };
}