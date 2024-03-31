{
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

  programs.gh.enable = true;
  programs.gitui.enable = true;
}
