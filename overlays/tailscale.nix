{
  addPatches,
  prev,
  ...
}: {
  tailscale = addPatches prev.tailscale [
    # Reverts "cmd/tailscaled/tailscaled.service: revert recent hardening"
    (prev.fetchpatch {
      url = "https://github.com/tailscale/tailscale/commit/2889fabaefc50040507ead652d6d2b212f476c2b.patch";
      hash = "sha256-DPBrv7kjSVXhmptUGGzOkaP4iXi/Bym3lvqy4otL9HE=";
      revert = true;
    })
  ];
}
