{
  description = "Build LineageOS for Redmi K60 Pro";

  inputs.robotnix.url = "github:danielfullmer/robotnix";

  outputs = inputs: {
    packages.x86_64-linux.default = inputs.self.robotnixConfigurations."socrates".img;

    # FIXME: it doesn't build
    # hardware/qcom-caf/sm8550/audio/pal/test/PalTest_main.c:56:32: error: unused parameter 'sig' [-Werror,-Wunused-parameter]
    # static void sigint_handler(int sig)
    #                                ^
    # 1 error generated.
    robotnixConfigurations."socrates" = inputs.robotnix.lib.robotnixSystem ({pkgs, ...}: {
      device = "socrates";
      flavor = "lineageos";
      androidVersion = 13;

      apps.chromium.enable = false;
      webview.chromium.enable = false;

      ccache.enable = true;

      source.dirs."device/xiaomi/socrates".src = pkgs.fetchFromGitHub {
        owner = "kmiit";
        repo = "android_device_xiaomi_socrates";
        rev = "6548361fe50743d6fe752f5848f63f9965d12d23";
        hash = "sha256-traXLuq74MTfUStOqyX3QBBbYAQEtXWTP9PpBjVfK/o=";
      };
      source.dirs."device/xiaomi/socrates".patches = [./disable-gapps.patch];

      source.dirs."device/xiaomi/socrates-kernel".src = pkgs.fetchFromGitHub {
        owner = "xiaomi-socrates";
        repo = "android_device_xiaomi_socrates-kernel";
        rev = "f13d073698b678442a694b2b2e3eecc997bb5227";
        hash = "sha256-Ln7rhdJNbj8imUUaitnUhXMj36Wjuf5IB8UmD6Y1o4c";
      };

      source.dirs."hardware/xiaomi".src = pkgs.fetchFromGitHub {
        owner = "cupid-development";
        repo = "android_hardware_xiaomi";
        rev = "b5167f21ba268a029461bded3f12205e5600b9f0";
        hash = "sha256-69nyWSjFrTjVsZdX92NZ5lv1H14mtC9dGepaD+nwvhY=";
      };

      source.dirs."vendor/xiaomi/socrates".src = pkgs.fetchFromGitHub {
        owner = "kmiit";
        repo = "android_vendor_xiaomi_socrates";
        rev = "8808c2f06a7645eaccb4992193f24c188b908418";
        hash = "sha256-jPZxWtTpj5a+EoIVmkU4L0dQD4926HyeM6BE2/1swDw=";
      };
    });
  };
}
