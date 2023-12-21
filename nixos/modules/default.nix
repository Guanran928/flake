{...}: {
  imports = [
    # utils that is used internally
    ./myFlake

    # nixpkgs styled options
    ./services
  ];
}
