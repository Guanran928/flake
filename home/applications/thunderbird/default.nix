{pkgs, ...}: {
  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird-128;
    profiles.default = {
      isDefault = true;
      extraConfig = ''
        ${builtins.readFile (builtins.fetchurl {
          url = "https://raw.githubusercontent.com/HorlogeSkynet/thunderbird-user.js/824edabe6303d6b85a32fcba96901706ed4c5922/user.js";
          sha256 = "0jg7i39yp21r66azlzk7978qj57rgb8c09d1hccpcw058isgymq6";
        })}
        ${builtins.readFile ./user-overrides.js}
      '';
    };
  };
}
