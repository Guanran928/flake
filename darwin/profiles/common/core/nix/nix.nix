{
  lib,
  pkgs,
  config,
  ...
}: {
  nix.settings = {
    trusted-users = ["@admin"];
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
    use-xdg-base-directories = true;
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Set Git commit hash for darwin-version.
  #system.configurationRevision = self.rev or self.dirtyRev or null;
}
