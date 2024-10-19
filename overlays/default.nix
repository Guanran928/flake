let
  addPatches =
    pkg: patches:
    pkg.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ patches;
    });
in
_final: prev: {
  # https://aur.archlinux.org/pkgbase/nautilus-typeahead
  nautilus = prev.nautilus.overrideAttrs {
    src = prev.fetchFromGitLab {
      domain = "gitlab.gnome.org";
      owner = "albertvaka";
      repo = "nautilus";
      rev = "f5f593bf36c41756a29d5112a10cf7ec70b8eafb";
      hash = "sha256-PfkCY2gQ8jfPIgTRC9Xzxh4N3f2oB339Hym5RCbKwkw=";
    };

    # Enable type-ahead behavior by default
    postPatch = ''
      awk -i inplace '/type-ahead-search/{c++;} c==1 && /true/{sub("true", "false"); c++;} 1' data/org.gnome.nautilus.gschema.xml
    '';
  };

  qt6Packages = prev.qt6Packages.overrideScope (
    _final': prev': {
      # HACK: no more qt5
      fcitx5-with-addons = prev'.fcitx5-with-addons.override {
        libsForQt5.fcitx5-qt = prev.emptyDirectory;
      };

      # HACK: no more qtwebengine, opencc
      fcitx5-chinese-addons =
        (prev'.fcitx5-chinese-addons.override {
          curl = prev.emptyDirectory;
          opencc = prev.emptyDirectory;
          qtwebengine = prev.emptyDirectory;
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
  gnome-themes-extra =
    (prev.gnome-themes-extra.override { gtk2 = prev.emptyDirectory; }).overrideAttrs
      { configureFlags = [ "--disable-gtk2-engine" ]; };

  sway-unwrapped = addPatches prev.sway-unwrapped [
    # text_input: Implement input-method popups
    # https://github.com/swaywm/sway/pull/7226
    (prev.fetchpatch2 {
      name = "0001-text_input-Implement-input-method-popups.patch";
      url = "https://github.com/swaywm/sway/commit/de74d1f6360810c0a5fd11d8022fbffe56fc97c5.patch";
      hash = "sha256-iTZIYHBp8vxjVdmH/k+jlN0/Zj6Ofe/qefv7ubtowHs=";
    })
    (prev.fetchpatch2 {
      name = "0002-chore-fractal-scale-handle.patch";
      url = "https://github.com/swaywm/sway/commit/2aa72e8dfd3b3d051fdec6b2d05c5635adcfb57b.patch";
      hash = "sha256-aJYXoZ7xEEy8J8DjxANOe14HdHRni6IXSNcAzLzNvIo=";
    })
    (prev.fetchpatch2 {
      name = "0003-chore-left_pt-on-method-popup.patch";
      url = "https://github.com/swaywm/sway/commit/0789c12a8edf46fbc1c7024e153f3e8f8f35fe12.patch";
      hash = "sha256-zvhp5eXqDngMNtctzVpryZY3zKi3IVjV7oFIBMC2jMk=";
    })

    # Tray D-Bus Menu
    # https://github.com/swaywm/sway/pull/6249
    (prev.fetchpatch2 {
      name = "0001-Tray-Implement-dbusmenu.patch";
      url = "https://github.com/NickHu/sway/commit/0fc5d7aed84415a77b718ca9dc3c0b3ad2c05b02.patch";
      hash = "sha256-eosg6m2P6e8NRXjOAQL3SZg+Yc4Av9Wd+LOy0G3+xkA=";
    })
    (prev.fetchpatch2 {
      name = "0002-Tray-dont-invoke-dbus-menu-when-tray-is-disabled.patch";
      url = "https://github.com/NickHu/sway/commit/03c14421354e54332e12f78d029dcaa9919fd161.patch";
      hash = "sha256-8RGtpfN/tnkA7nuGdXGHoKUoKVeG7brSQR6V4RU3z88=";
    })
    (prev.fetchpatch2 {
      name = "0003-swaybar-dbusmenu-fix-crash-if-the-program-exits-while-menu.patch";
      url = "https://github.com/llyyr/sway/commit/84481c26a4c55674da5804bb2619d3575ba405b3.patch";
      hash = "sha256-+JJoHNOmDzqT1TaFM83DR3/BdCab240tfs21VNMv6wE=";
    })
  ];
}
