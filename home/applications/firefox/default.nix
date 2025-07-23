{ lib, pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      extraPrefsFiles = [
        (pkgs.runCommandLocal "userjs" { } ''
          substitute ${pkgs.arkenfox-userjs}/user.js $out \
            --replace-fail 'user_pref' 'lockPref'
        '')
        (pkgs.runCommandLocal "userjs" { } ''
          substitute ${./user-overrides.js} $out \
            --replace-fail 'user_pref' 'lockPref'
        '')
      ];
    };

    policies.ExtensionSettings = {
      "*" = {
        installation_mode = "blocked";
      };
    }
    // lib.listToAttrs (
      map
        (x: {
          name = x;
          value = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${x}/latest.xpi";
            installation_mode = "force_installed";
          };
        })
        [
          "redirector@einaregilsson.com" # redirector
          "sponsorBlocker@ajay.app" # sponsorblock
          "uBlock0@raymondhill.net" # ublock origin
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" # bitwarden
          "{d7742d87-e61d-4b78-b8a1-b469842139fa}" # vimium
        ]
    );

    profiles."default" = { };
  };
}
