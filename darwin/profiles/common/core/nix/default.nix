{...}: {
  imports = [
    ./flake.nix
    ./nix.nix
    #./gc.nix # wtf is single user mode
  ];
}
