_final: prev: {
  sway-unwrapped =
    (prev.sway-unwrapped.overrideAttrs (old: {
      version = "1.10-unstable-2024-03-01";
      src = prev.fetchFromGitHub {
        owner = "swaywm";
        repo = "sway";
        rev = "5e18ed3cf03eee9e83909fede46dd98dff652647";
        hash = "sha256-O0Kh+pnB1Hxc0TBZuAMVLkCYY6BBsSesvvYD923zDvo=";
      };

      patches =
        old.patches
        ++ [
          # (rebased) Tray D-Bus Menu
          # https://github.com/swaywm/sway/pull/6249
          ./0001-Tray-Implement-dbusmenu.patch
        ];
    }))
    .override {
      wlroots = prev.wlroots.overrideAttrs {
        version = "1.18.0-unstable-2024-03-05";
        src = prev.fetchFromGitLab {
          domain = "gitlab.freedesktop.org";
          owner = "wlroots";
          repo = "wlroots";
          rev = "31c842e5ece93145604c65be1b14c2f8cee24832";
          hash = "sha256-otjJDgWBgn1Wk1e46Y3wr/eEvOsQPTP9jjaX9dlFcjA=";
        };
      };
    };
}
