{
  picom,
  pcre2,
  fetchFromGitHub,
}:
picom.overrideAttrs (old: {
  pname = "picom-ft-labs";
  version = "unstable-2024-01-22";

  src = fetchFromGitHub {
    owner = "FT-Labs";
    repo = "picom";
    rev = "fe5b416ed6f43c31418d21dde7a9f20c12d7dfb0";
    sha256 = "sha256-jouBx8fqoy/psD/P9dX3Q4/D4IWsLSxA210CKcBbh4I=";
  };

  buildInputs = old.buildInputs ++ [pcre2];

  meta = {
    description = "A fork of Picom with more than 10 unique animation supported picom fork (open window, tag change, fading ...)";
    homepage = "https://github.com/FT-Labs/picom";
  };
})
