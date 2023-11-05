{lib, ...}: {
  nix.settings = {
    trusted-users = ["@wheel"];
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store" # USTC - 中国科学技术大学 Mirror
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" # TUNA - 清华大学 Mirror
      "https://mirrors.bfsu.edu.cn/nix-channels/store" # BFSU - 北京外国语大学 Mirror
      "https://mirror.sjtu.edu.cn/nix-channels/store" # SJTU - 上海交通大学 Mirror

      "https://nix-community.cachix.org"
      "https://cache.garnix.io"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
    use-xdg-base-directories = true;
  };

  documentation = {
    doc.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  system = {
    # Copy the NixOS configuration file and link it from the resulting system
    # (/run/current-system/configuration.nix). This is useful in case you
    # accidentally delete configuration.nix.

    # Does not work with flake based configurations
    copySystemConfiguration = lib.mkDefault true;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It's perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

    # TLDR: leave it alone
    stateVersion = "23.05";
  };
}
