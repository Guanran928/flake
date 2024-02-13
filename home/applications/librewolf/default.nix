_: {
  programs.librewolf = {
    enable = true;
    settings = {
      # https://codeberg.org/librewolf/settings/src/branch/master/librewolf.cfg
      # https://github.com/yokoffing/Betterfox/blob/main/librewolf.overrides.cfg

      ### Restore disabled functions
      "browser.cache.disk.enable" = true;
      "identity.fxaccounts.enabled" = true;
      "media.eme.enabled" = true;
      "privacy.donottrackheader.enabled" = false;
      "privacy.globalprivacycontrol.enabled" = false;
      "privacy.resistFingerprinting" = false;
      "privacy.sanitize.sanitizeOnShutdown" = false;
      "security.OCSP.enabled" = 0;
      "security.OCSP.require" = false;
      "security.pki.crlite_mode" = 2;
      "webgl.disabled" = false;

      ### Smooth scrolling
      "apz.overscroll.enabled" = true;
      "general.smoothScroll" = true;
      "general.smoothScroll.msdPhysics.enabled" = true;
      "general.smoothScroll.msdPhysics.motionBeginSpringConstant" = 600;
      "mousewheel.default.delta_multiplier_y" = 75;

      ### Misc
      "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
    };
  };

  home.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };
}
