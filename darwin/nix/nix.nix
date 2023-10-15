{ pkgs, ... }:

{
  nix.settings = {
    trusted-users = [ "@admin" ];
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"            # USTC - 中国科学技术大学 Mirror
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"   # TUNA - 清华大学 Mirror
      "https://mirrors.bfsu.edu.cn/nix-channels/store"            # BFSU - 北京外国语大学 Mirror
      "https://mirror.sjtu.edu.cn/nix-channels/store"             # SJTU - 上海交通大学 Mirror

      "https://nix-community.cachix.org"
      "https://cache.garnix.io"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
    use-xdg-base-directories = true;
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Set Git commit hash for darwin-version.
  #system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
