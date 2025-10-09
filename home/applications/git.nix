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
      column.ui = "auto";
      credential.helper = "${package}/bin/git-credential-libsecret";
      diff.algorithm = "histogram";
      feature.experimental = true;
      grep.patternType = "perl";
      init.defaultBranch = "master";
      log.date = "iso";
      pull.rebase = true;
      push.autoSetupRemote = true;
      rebase.autoStash = true;
      rerere.autoupdate = true;
      rerere.enabled = true;
      tag.sort = "version:refname";
    };
  };

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
