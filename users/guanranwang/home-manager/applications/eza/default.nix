{
  programs.eza = {
    enable = true;
    git = true;
    icons = true;
    extraOptions = ["--header"];
    # Fish have builtin aliases for `ls`, alias `ls` to `eza` is the only thing we want to do
    #enableAliases = true;
  };

  home.shellAliases = {
    "ls" = "eza";
    "tree" = "ls --tree";
  };
}
