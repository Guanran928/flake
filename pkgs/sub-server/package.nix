{ lib, buildGoModule }:
buildGoModule {
  pname = "sub-server";
  version = "dev";

  src = lib.cleanSource ../../fn/sub-server;

  ldflags = [
    "-s"
    "-w"
  ];

  vendorHash = null;

  meta.mainProgram = "sub-server";
}
