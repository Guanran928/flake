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
  programs.gitui.enable = true;

  # vim keybinds
  # https://github.com/extrawurst/gitui/blob/master/KEY_CONFIG.md
  programs.gitui.keyConfig = ''
    (
      move_left: Some(( code: Char('h'), modifiers: "")),
      move_right: Some(( code: Char('l'), modifiers: "")),
      move_up: Some(( code: Char('k'), modifiers: "")),
      move_down: Some(( code: Char('j'), modifiers: "")),

      stash_open: Some(( code: Char('l'), modifiers: "")),
      open_help: Some(( code: F(1), modifiers: "")),

      status_reset_item: Some(( code: Char('U'), modifiers: "SHIFT")),
    )
  '';
}
