{
  lib,
  alsa-lib,
  avahi-compat,
  boost,
  cmake,
  fetchFromGitHub,
  flac,
  libjack2,
  libogg,
  libopus,
  libpulseaudio,
  libsndfile,
  libvorbis,
  nixosTests,
  pipewire,
  pkg-config,
  poco,
  protobuf,
  python3,
  qt6,
  rnnoise,
  speechd,
  speex,
  stdenv,
  jackSupport ? false,
  pipewireSupport ? true,
  pulseSupport ? true,
  speechdSupport ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mumble";
  version = "1.5.634-unstable-2024-10-05";

  src = fetchFromGitHub {
    owner = "mumble-voip";
    repo = "mumble";
    rev = "cb01bfa5200fce53db68b769d05995c999e7cdd8";
    hash = "sha256-Tf029ae+PfFPhchU45y96IJVeY9GPzWD2E+NprI/ZYk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    qt6.wrapQtAppsHook
    qt6.qttools
  ];

  buildInputs =
    [
      avahi-compat
      boost
      flac
      libogg
      libopus
      libsndfile
      libvorbis
      poco
      protobuf
      qt6.qtsvg
      rnnoise
      speex
    ]
    ++ lib.optional (!jackSupport) alsa-lib
    ++ lib.optional jackSupport libjack2
    ++ lib.optional speechdSupport speechd
    ++ lib.optional pulseSupport libpulseaudio
    ++ lib.optional pipewireSupport pipewire;

  env.NIX_CFLAGS_COMPILE = lib.optionalString speechdSupport "-I${speechd}/include/speech-dispatcher";

  cmakeFlags =
    [
      "-D g15=OFF"
      "-D server=OFF"
      "-D bundled-celt=ON"
      "-D bundled-opus=OFF"
      "-D bundled-speex=OFF"
      "-D bundle-qt-translations=OFF"
      "-D update=OFF"
      "-D overlay-xcompile=OFF"
      "-D oss=OFF"
      "-D warnings-as-errors=OFF" # conversion error workaround
    ]
    ++ lib.optional (!speechdSupport) "-D speechd=OFF"
    ++ lib.optional (!pulseSupport) "-D pulseaudio=OFF"
    ++ lib.optional (!pipewireSupport) "-D pipewire=OFF"
    ++ lib.optional jackSupport "-D alsa=OFF -D jackaudio=ON";

  preConfigure = ''
    patchShebangs scripts
  '';

  postFixup = ''
    wrapProgram $out/bin/mumble \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath (
          lib.optional pulseSupport libpulseaudio ++ lib.optional pipewireSupport pipewire
        )
      }"
  '';

  passthru.tests.connectivity = nixosTests.mumble;

  meta = {
    description = "Low-latency, high quality voice chat software";
    homepage = "https://mumble.info";
    license = lib.licenses.bsd3;
    mainProgram = "mumble";
    maintainers = with lib.maintainers; [
      felixsinger
      lilacious
    ];
    platforms = lib.platforms.linux;
  };
})
