{ pkgs, ... }:
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
      "redirector@einaregilsson.com" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/redirector/latest.xpi";
        installation_mode = "force_installed";
      };
      "sponsorBlocker@ajay.app" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
        installation_mode = "force_installed";
      };
      "uBlock0@raymondhill.net" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        installation_mode = "force_installed";
      };
      "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        installation_mode = "force_installed";
      };
      "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
        installation_mode = "force_installed";
      };
    };

    profiles."default" = { };
  };
}
