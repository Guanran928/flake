{
  lib,
  buildGoModule,
  fetchFromGitea,
  makeBinaryWrapper,
}:
buildGoModule rec {
  pname = "pixivfe";
  version = "2.6";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "VnPower";
    repo = "PixivFE";
    rev = "v${version}";
    hash = "sha256-pusyCXy2tsdvOSUR6LfSYHv8YT1tiCErqUEkUgKYbZ4=";
  };

  vendorHash = "sha256-QapDR964Tn+RxXdkGqCQXacdmlSapF841Y84n4d/6VI=";

  ldflags = ["-s" "-w"];

  nativeBuildInputs = [makeBinaryWrapper];

  # PixivFE require files from source code
  postInstall = ''
    wrapProgram $out/bin/pixivfe \
      --chdir ${src}
  '';

  meta = {
    description = "A privacy respecting frontend for Pixiv";
    homepage = "https://codeberg.org/VnPower/PixivFE";
    license = lib.licenses.agpl3Only;
    mainProgram = "pixivfe";
    maintainers = with lib.maintainers; [Guanran928];
    platforms = lib.platforms.linux;
  };
}
