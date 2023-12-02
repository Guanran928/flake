_: {
  programs.skim = {
    enable = true;
    defaultCommand = "rg --files || fd --type f || find .";
    # rg --files ran
    #   4.40 ± 0.44 times faster than fd --type f
    #  60.39 ± 5.80 times faster than find .
  };
}
