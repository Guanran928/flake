{
  programs.skim = {
    enable = true;

    # SPEED: fd > rg > find
    # STARTUP TIME: find > rg > fd
    defaultCommand = "fd --color never || rg --files --color never || find";
  };
}
