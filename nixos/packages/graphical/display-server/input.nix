{ ... }:

{
  services.xserver = {
    libinput = {
      enable = true;
      touchpad = {
        accelProfile = "flat";
        naturalScrolling = true;
        middleEmulation = false;
      };
      mouse = {
        accelProfile = "flat";
        naturalScrolling = true;
        middleEmulation = false;
      };
    };
  };

  ### Removes debounce time
  # https://www.reddit.com/r/linux_gaming/comments/ku6gth
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Never Debounce]
    MatchUdevType=mouse
    ModelBouncingKeys=1
  '';
}
