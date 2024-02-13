{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    profiles."default" = {
      extraConfig = ''
        ${builtins.readFile (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/arkenfox/user.js/122.0/user.js";
          hash = "sha256-H3Nk5sDxSElGRgK+cyQpVyjtlMF2Okxbstu9A+eJtGk=";
        })}
        ${builtins.readFile ./user-overrides.js}
      '';
    };
  };

  home.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };
}
