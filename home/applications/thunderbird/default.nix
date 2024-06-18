{pkgs, ...}: {
  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
      extraConfig = ''
        ${builtins.readFile (pkgs.fetchurl {
          # FIXME: IFD
          url = "https://raw.githubusercontent.com/HorlogeSkynet/thunderbird-user.js/d6b18302e46349d9924c8a76951bae6efca51501/user.js";
          hash = "sha256-66B1yLQkQnydAUXD7KGt32OhWSYcdWX+BUozrgW9uAg=";
        })}
        ${builtins.readFile ./user-overrides.js}
      '';
    };
  };
}
