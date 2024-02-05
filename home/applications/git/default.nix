{
  programs.gh.enable = true;
  programs.git = {
    enable = true;
    userName = "Guanran Wang";
    userEmail = "guanran928@outlook.com";
    delta.enable = true;
    signing.signByDefault = true;
    signing.key = "~/.ssh/id_github_signing";
    extraConfig = {
      gpg.format = "ssh";
      pull.rebase = true;
    };
  };

  xdg.configFile."gh/hosts.yml".text = ''
    github.com:
      git_protocol: https
      user: Guanran928
  '';
}
