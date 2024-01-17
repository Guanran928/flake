{pkgs, ...}: {
  home.packages = [pkgs.lunarvim];
  programs.neovim = {
    enable = true;
    #defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
  xdg.configFile."nvim".source = pkgs.fetchFromGitHub {
    owner = "Guanran928";
    repo = "nvim";
    rev = "655e863d2548cf9883e94e837f803ed2ae0d6aec";
    hash = "sha256-EYArlahHMWj4yVXTKldVZsbHjg0gxvXqgTxO5BvEfQ8=";
  };
}
