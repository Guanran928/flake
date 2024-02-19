{pkgs, ...}: {
  #home.packages = [pkgs.lunarvim];
  programs.neovim = {
    enable = true;
    #defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
  xdg.configFile."nvim".source = pkgs.fetchFromGitHub {
    owner = "Guanran928";
    repo = "nvim";
    rev = "2a3a14de15d28f97dafea4be6e91df72d4a45e42";
    hash = "sha256-CFdRSYAC5FPPC45gc+vSYpSHfZL78Wf7IugA6pEASXE=";
  };
}
