{config, ...}: {
  nix.settings = {
    substituters =
      {
        "Asia/Shanghai" = [
          "https://mirror.sjtu.edu.cn/nix-channels/store" # SJTU - 上海交通大学 Mirror
          "https://mirrors.ustc.edu.cn/nix-channels/store" # USTC - 中国科学技术大学 Mirror
          "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" # TUNA - 清华大学 Mirror
        ];
      }
      .${config.time.timeZone}
      or []
      ++ [
        "https://nix-community.cachix.org"
        "https://cache.garnix.io"
        "https://berberman.cachix.org"
        "https://hyprland.cachix.org"
        "https://nix-gaming.cachix.org"
      ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "berberman.cachix.org-1:UHGhodNXVruGzWrwJ12B1grPK/6Qnrx2c3TjKueQPds="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];

    trusted-users = ["@wheel"];
    experimental-features = ["auto-allocate-uids" "cgroups"];
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
}
