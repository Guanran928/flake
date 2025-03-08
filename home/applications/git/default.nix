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
      branch.ui = "auto";
      credential.helper = "${package}/bin/git-credential-libsecret";
      diff.algorithm = "histogram";
      feature.experimental = true;
      init.defaultBranch = "master";
      log.date = "iso";
      pull.rebase = true;
      push.autoSetupRemote = true;
      rebase.autoStash = true;
      tag.sort = "version:refname";
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
