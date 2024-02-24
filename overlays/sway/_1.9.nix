_final: prev: {
  sway-unwrapped = prev.sway-unwrapped.overrideAttrs rec {
    version = "1.9";

    src = prev.fetchFromGitHub {
      owner = "swaywm";
      repo = "sway";
      rev = version;
      hash = "sha256-/6+iDkQfdLcL/pTJaqNc6QdP4SRVOYLjfOItEu/bZtg";
    };

    buildInputs = with prev; [
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
      wlroots_0_17
      xorg.xcbutilwm
    ];

    patches = [];
  };
}
