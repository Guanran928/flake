_final: prev: {
  sway-unwrapped = prev.sway-unwrapped.overrideAttrs (old: {
    version = "1.10-unstable-2024-02-23";
    src = prev.fetchFromGitHub {
      owner = "swaywm";
      repo = "sway";
      rev = "fc640d5f6c82883c35e90a64f0098486e6091293";
      hash = "sha256-n0U1RoSv3fuOkey2gXPX+O4mRA2PCASpkRrIE5069BI";
    };

    buildInputs = with prev; [
      (wlroots.overrideAttrs {
        version = "1.18.0-unstable-2024-02-23";
        src = prev.fetchFromGitLab {
          domain = "gitlab.freedesktop.org";
          owner = "wlroots";
          repo = "wlroots";
          rev = "54e1fefd2e29cb00dff7c02801913d793ceab7d6";
          hash = "sha256-VX2AAzcYl255yF43+uetcOS+uYzAVfk7WccWONpjmYU=";
        };
      })

      cairo
      gdk-pixbuf
      json_c
      libGL
      libdrm
      libevdev
      libinput
      librsvg
      libxkbcommon
      pango
      pcre2
      wayland
      wayland-protocols
      xorg.xcbutilwm
    ];

    patches = let
      removePatches = ["LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch"];
    in
      builtins.filter (patch: !builtins.elem (patch.name or null) removePatches) (old.patches or [])
      ++ [
        # rebased version of https://github.com/swaywm/sway/pull/6249
        # using sed at this point is just stupid (see ./_1.8.nix)
        ./0001-Tray-Implement-dbusmenu.patch
      ];
  });
}
