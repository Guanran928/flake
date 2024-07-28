{
  programs.git = {
    enable = true;
    delta.enable = true;

    userName = "Guanran Wang";
    userEmail = "guanran928@outlook.com";
    signing.signByDefault = true;
    signing.key = "91F97D9ED12639CF";

    extraConfig = {
      init.defaultBranch = "master";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  programs.gh.enable = true;
  programs.gitui.enable = true;
}
