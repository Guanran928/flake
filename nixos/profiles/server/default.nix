{modulesPath, ...}:
# no i dont actually own a server
{
  imports = [
    (modulesPath + "/profiles/minimal.nix")
    ../core
  ];
}
