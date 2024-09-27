{ pkgs, ... }:
{
  programs.git = rec {
    enable = true;
    package = pkgs.gitFull; # overriding takes forever to compile
    delta.enable = true;

    userName = "Guanran Wang";
    userEmail = "guanran928@outlook.com";
    signing.signByDefault = true;
    signing.key = "91F97D9ED12639CF";

    extraConfig = {
      init.defaultBranch = "master";
      pull.rebase = true;
      push.autoSetupRemote = true;
      credential.helper = "${package}/bin/git-credential-libsecret";
    };
  };

  programs.gh.enable = true;

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        nerdFontsVersion = "3";
        showRandomTip = false;
        showBottomLine = false;
      };
      git = {
        paging.pager = "delta --paging=never";
      };
    };
  };
}
