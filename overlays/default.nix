_final: prev: {
  qt6Packages = prev.qt6Packages.overrideScope (
    _final': prev': {
      # HACK: no more qt5
      fcitx5-with-addons = prev'.fcitx5-with-addons.override { libsForQt5.fcitx5-qt = null; };

      # HACK: no more kde stuff
      fcitx5-configtool = prev'.fcitx5-configtool.override { kcmSupport = false; };

      # HACK: no more qtwebengine
      fcitx5-chinese-addons =
        (prev'.fcitx5-chinese-addons.override { qtwebengine = null; }).overrideAttrs
          (oldAttrs: {
            cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [ (prev.lib.cmakeBool "ENABLE_BROWSER" false) ];
          });
    }
  );

  # HACK: no more gtk2
  gnome-themes-extra = (prev.gnome-themes-extra.override { gtk2 = null; }).overrideAttrs {
    configureFlags = [ "--disable-gtk2-engine" ];
  };

  # HACK:
  xdg-desktop-portal-gtk =
    (prev.xdg-desktop-portal-gtk.override {
      gnome-settings-daemon = null;
      gnome-desktop = null;
      gsettings-desktop-schemas = null;
    }).overrideAttrs
      (oldAttrs: {
        mesonFlags = (oldAttrs.mesonFlags or [ ]) ++ [ (prev.lib.mesonEnable "wallpaper" false) ];
      });

  mautrix-telegram = prev.mautrix-telegram.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ [
      (prev.fetchpatch2 {
        url = "https://github.com/mautrix/telegram/commit/0c2764e3194fb4b029598c575945060019bad236.patch";
        hash = "sha256-48QiKByX/XKDoaLPTbsi4rrlu9GwZM26/GoJ12RA2qE=";
      })
    ];
  });
}
