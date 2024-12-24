_final: prev: {
  qt6Packages = prev.qt6Packages.overrideScope (
    _final': prev': {
      # HACK: no more qt5
      fcitx5-with-addons = prev'.fcitx5-with-addons.override { libsForQt5.fcitx5-qt = null; };

      # HACK: no more kde stuff
      fcitx5-configtool = prev'.fcitx5-configtool.override { kcmSupport = false; };

      # HACK: no more qtwebengine, opencc
      fcitx5-chinese-addons =
        (prev'.fcitx5-chinese-addons.override {
          curl = null;
          opencc = null;
          qtwebengine = null;
        }).overrideAttrs
          (oldAttrs: {
            buildInputs = oldAttrs.buildInputs ++ [
              prev.gettext
              prev'.qtbase
            ];
            cmakeFlags = oldAttrs.cmakeFlags ++ [
              (prev.lib.cmakeBool "ENABLE_BROWSER" false)
              (prev.lib.cmakeBool "ENABLE_CLOUDPINYIN" false)
              (prev.lib.cmakeBool "ENABLE_OPENCC" false)
            ];
          });
    }
  );

  # HACK: no more gtk2
  gnome-themes-extra = (prev.gnome-themes-extra.override { gtk2 = null; }).overrideAttrs {
    configureFlags = [ "--disable-gtk2-engine" ];
  };

  # TODO:
  # sway-unwrapped = prev.sway-unwrapped.overrideAttrs (oldAttrs: {
  #   patches = (oldAttrs.patches or [ ]) ++ [
  #     # Tray D-Bus Menu
  #     # https://github.com/swaywm/sway/pull/6249
  #     (prev.fetchpatch2 {
  #       name = "0001-Tray-Implement-dbusmenu.patch";
  #       url = "https://github.com/NickHu/sway/commit/0fc5d7aed84415a77b718ca9dc3c0b3ad2c05b02.patch";
  #       hash = "sha256-eosg6m2P6e8NRXjOAQL3SZg+Yc4Av9Wd+LOy0G3+xkA=";
  #     })
  #     (prev.fetchpatch2 {
  #       name = "0002-Tray-dont-invoke-dbus-menu-when-tray-is-disabled.patch";
  #       url = "https://github.com/NickHu/sway/commit/03c14421354e54332e12f78d029dcaa9919fd161.patch";
  #       hash = "sha256-8RGtpfN/tnkA7nuGdXGHoKUoKVeG7brSQR6V4RU3z88=";
  #     })
  #     (prev.fetchpatch2 {
  #       name = "0003-swaybar-dbusmenu-fix-crash-if-the-program-exits-while-menu.patch";
  #       url = "https://github.com/llyyr/sway/commit/84481c26a4c55674da5804bb2619d3575ba405b3.patch";
  #       hash = "sha256-+JJoHNOmDzqT1TaFM83DR3/BdCab240tfs21VNMv6wE=";
  #     })
  #   ];
  # });
}
