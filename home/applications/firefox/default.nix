{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    profiles."default" = {
      extraConfig = ''
        ${builtins.readFile (builtins.fetchurl {
          url = "https://raw.githubusercontent.com/arkenfox/user.js/126.1/user.js";
          sha256 = "sha256-XRtG0iLKh8uqbeX7Rc2H6VJwZYJoNZPBlAfZEfrSCP4=";
        })}
        ${builtins.readFile ./user-overrides.js}
      '';
    };
  };
}
