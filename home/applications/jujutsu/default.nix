{ pkgs, ... }:
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Guanran Wang";
        email = "guanran928@outlook.com";
      };
      signing = {
        behavior = "own";
        backend = "gpg";
        key = "91F97D9ED12639CF";
      };
    };
  };
}
