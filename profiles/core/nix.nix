{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  nix.settings = {
    substituters =
      (lib.optionals (config.time.timeZone == "Asia/Shanghai") [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" # TUNA - 清华大学 Mirror
      ])
      ++ [ "https://nix-community.cachix.org" ];
    trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];

    experimental-features = [
      "auto-allocate-uids"
      "cgroups"
      "flakes"
      "nix-command"
      "no-url-literals"
    ];
    flake-registry = "";
    trusted-users = [ "@wheel" ];
    allow-import-from-derivation = false;
    auto-allocate-uids = true;
    auto-optimise-store = true;
    builders-use-substitutes = true;
    use-cgroups = true;
    use-xdg-base-directories = true;
  };

  nix = {
    package = pkgs.nixVersions.latest;

    # Add each flake input as a registry
    # To make nix3 commands consistent with the flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # Disable nix-channel
    channel.enable = false;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
