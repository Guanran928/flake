{
  lib,
  config,
  ...
}: {
  nix.settings = {
    substituters =
      (lib.optionals (config.time.timeZone == "Asia/Shanghai") [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" # TUNA - 清华大学 Mirror
      ])
      ++ [
        "https://nix-community.cachix.org"
        "https://guanran928.cachix.org"
      ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "guanran928.cachix.org-1:BE/iBCj2/pqJXG908wHRrcaV0B2fC+KbFjHsXY6b91c="
    ];

    trusted-users = ["@wheel"];
    experimental-features = [
      "auto-allocate-uids"
      "cgroups"
      "no-url-literals"
    ];
    allow-import-from-derivation = false;
    auto-allocate-uids = true;
    builders-use-substitutes = true;
    use-cgroups = true;
    use-xdg-base-directories = true;
  };

  documentation = {
    doc.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  # https://github.com/NixOS/nixpkgs/pull/308801
  # nixos/switch-to-configuration: add new implementation
  system.switch = {
    enable = false;
    enableNg = true;
  };
}
