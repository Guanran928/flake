{...}: {
  ### For NixOS
  imports = [
    ./music.nix
    ./photo.nix
    ./video.nix
  ];
}
