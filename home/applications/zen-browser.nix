{ lib, inputs, ... }:
{
  imports = [ inputs.zen-browser.homeModules.twilight ];

  programs.zen-browser = {
    enable = true;

    policies = {
      DisableFirefoxStudies = true;
      DisableTelemetry = true;
      PasswordManagerEnabled = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };
      FirefoxHome = {
        Locked = true;
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        Stories = false;
        SponsoredPocket = false;
        SponsoredStories = false;
        Snippets = false;
      };
      FirefoxSuggest = {
        Locked = true;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
      };
    };

    policies.Preferences = {
      "browser.tabs.closeWindowWithLastTab" = false;
      "browser.tabs.inTitlebar" = 0;
      "zen.theme.content-element-separation" = 0;
      "zen.view.experimental-no-window-controls" = true;
    };

    policies.ExtensionSettings = lib.listToAttrs (
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
        ]
    );

    profiles."default" = { };
  };
}
