{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      extraPrefsFiles = [
        "${pkgs.arkenfox-userjs}/user.cfg"
        (pkgs.runCommandLocal "userjs" { } ''
          install -Dm644 ${./user-overrides.js} $out
          substituteInPlace $out \
            --replace-fail "user_pref" "defaultPref"
        '')
      ];
    };
    profiles."default" = { };
  };
}
