{
  inputs,
  pkgs,
  ...
}: let
  mkNixPak = inputs.nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  librewolf = mkNixPak {
    config = {
      config,
      sloth,
      ...
    }: {
      app.package = pkgs.librewolf;
      flatpak.appId = "io.gitlab.librewolf-community";

      imports = [
        (inputs.nixpak-pkgs + "/pkgs/modules/gui-base.nix")
        (inputs.nixpak-pkgs + "/pkgs/modules/network.nix")
      ];

      # Specified in https://github.com/schizofox/schizofox/blob/main/modules/hm/default.nix
      # I really don't have any idea what am I doing, it just works™
      dbus.policies = {
        "io.gitlab.librewolf.*" = "own";
      };

      bubblewrap = let
        envSuffix = envKey: sloth.concat' (sloth.env envKey);
      in {
        bind.rw = [
          "/tmp/.X11-unix"
          (sloth.envOr "XAUTHORITY" "/no-xauth")
          (envSuffix "XDG_RUNTIME_DIR" "/dconf")
          (sloth.concat' sloth.homeDir "/.librewolf")
          (sloth.concat' sloth.homeDir "/Downloads")
        ];
        bind.ro = [
          "/etc/localtime"
          "/sys/bus/pci"

          ["${config.app.package}/lib/firefox" "/app/etc/firefox"]
          (sloth.concat' sloth.xdgConfigHome "/dconf")
        ];
      };
    };
  };
in {
  programs.librewolf = {
    enable = true;
    package = librewolf.config.env;
    settings = {
      "identity.fxaccounts.enabled" = true;

      # https:#github.com/yokoffing/Betterfox/blob/main/librewolf.overrides.cfg
      ### SECTION: FASTFOX
      "layout.css.grid-template-masonry-value.enabled" = true;
      "dom.enable_web_task_scheduling" = true;

      ### SECTION: SECUREFOX
      # TRACKING PROTECTION
      "urlclassifier.trackingSkipURLs" = "*.reddit.com, *.twitter.com, *.twimg.com";
      "urlclassifier.features.socialtracking.skipURLs" = "*.instagram.com, *.twitter.com, *.twimg.com";

      ### OCSP & CERTS / HPKP
      # Use CRLite instead of OCSP
      "security.OCSP.enabled" = 0;
      "security.OCSP.require" = false;
      "security.pki.crlite_mode" = 2;

      ### RFP
      # Limits refresh rate to 60mHz, breaks timezone, and forced light theme
      # [1] https:#librewolf.net/docs/faq/#what-are-the-most-common-downsides-of-rfp-resist-fingerprinting
      "privacy.resistFingerprinting" = false;

      ### WebGL
      # Breaks Map sites, NYT articles, Nat Geo, and more
      # [1] https:#manu.ninja/25-real-world-applications-using-webgl/
      "webgl.disabled" = false;

      # DRM
      # Netflix, Udemy, Spotify, etc.
      "media.eme.enabled" = true;

      # HTTPS-ONLY MODE
      "dom.security.https_only_mode_error_page_user_suggestions" = true;

      # PASSWORDS AND AUTOFILL
      "signon.generation.enabled" = false;

      ### WEBRTC
      # Breaks video conferencing
      "media.peerconnection.ice.no_host" = false;

      ### PERMISSIONS
      "permissions.default.geo" = 2;
      "permissions.default.desktop-notification" = 2;
      "dom.push.enabled" = false;

      ### SECTION: PESKYFOX
      ### MOZILLA UI
      "layout.css.prefers-color-scheme.content-override" = 2;
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "browser.compactmode.show" = true;

      ### FULLSCREEN
      "full-screen-api.transition-duration.enter" = "0 0";
      "full-screen-api.transition-duration.leave" = "0 0";
      "full-screen-api.warning.delay" = 0;
      "full-screen-api.warning.timeout" = 0;

      ### URL BAR
      "browser.urlbar.suggest.engines" = false;
      "browser.urlbar.suggest.topsites" = false;
      "browser.urlbar.suggest.calculator" = true;
      "browser.urlbar.unitConversion.enabled" = true;

      ### AUTOPLAY
      # Default breaks some video players
      "media.autoplay.blocking_policy" = 0;

      #### PASSWORDS
      "editor.truncate_user_pastes" = false;

      #### DOWNLOADS
      "browser.download.autohideButton" = true;

      ### PDF
      "browser.download.open_pdf_attachments_inline" = true;

      ### TAB BEHAVIOR
      "browser.tabs.loadBookmarksInTabs" = true;
      "browser.bookmarks.openInTabClosesMenu" = false;
      "findbar.highlightAll" = true;

      ### SECTION: SMOOTHFOX
      "apz.overscroll.enabled" = true;
      "general.smoothScroll" = true;
      "general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS" = 12;
      "general.smoothScroll.msdPhysics.enabled" = true;
      "general.smoothScroll.msdPhysics.motionBeginSpringConstant" = 600;
      "general.smoothScroll.msdPhysics.regularSpringConstant" = 650;
      "general.smoothScroll.msdPhysics.slowdownMinDeltaMS" = 25;
      "general.smoothScroll.msdPhysics.slowdownMinDeltaRatio" = "2.0";
      "general.smoothScroll.msdPhysics.slowdownSpringConstant" = 250;
      "general.smoothScroll.currentVelocityWeighting" = "1.0";
      "general.smoothScroll.stopDecelerationWeighting" = "1.0";
      "mousewheel.default.delta_multiplier_y" = 75;
    };
  };
}
