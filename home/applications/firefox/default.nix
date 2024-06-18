{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    profiles."default" = {
      extraConfig = ''
        ${builtins.readFile (pkgs.fetchurl {
          # FIXME: IFD
          url = "https://raw.githubusercontent.com/arkenfox/user.js/126.1/user.js";
          hash = "sha256-XRtG0iLKh8uqbeX7Rc2H6VJwZYJoNZPBlAfZEfrSCP4=";
        })}
        ${builtins.readFile ./user-overrides.js}
      '';
    };
  };

  home.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };
}
