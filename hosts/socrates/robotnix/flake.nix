{
  description = "Build LineageOS for Redmi K60 Pro";

  inputs.robotnix.url = "github:danielfullmer/robotnix";

  outputs = inputs: {
    packages.x86_64-linux.default = inputs.self.robotnixConfigurations."socrates".img;

    robotnixConfigurations."socrates" = inputs.robotnix.lib.robotnixSystem ({pkgs, ...}: {
      device = "socrates";
      flavor = "lineageos";
      androidVersion = 14;

      apps.chromium.enable = false;
      webview.chromium.enable = false;

      ccache.enable = true;

      source.dirs."device/xiaomi/socrates".src = pkgs.fetchFromGitHub {
        owner = "danielml3";
        repo = "android_device_xiaomi_socrates";
        rev = "8b48a7a18b8db76d7122ca6e1b5bde8765d16665"; # lineage-21
        hash = "sha256-pQIbxpZhaxc7nI8Pl8sjG3kmvD3ComFDowjcKb9eZRo=";
      };

      source.dirs."device/xiaomi/socrates-kernel".src = pkgs.fetchFromGitHub {
        owner = "danielml3";
        repo = "android_device_xiaomi_socrates";
        rev = "60cd3aebf59cdf96366e8e4a8a1e2887f7d4d063"; # lineage-21-kernel
        hash = "sha256-i5QtxvApvGk24WeH6i6nC6jhS2jL2BolRUr/M02y6lc=";
      };

      source.dirs."hardware/xiaomi".src = pkgs.fetchFromGitHub {
        owner = "LineageOS";
        repo = "android_hardware_xiaomi";
        rev = "4453055456bb452830144d9526342b032289495e"; # lineage-21
        hash = "sha256-kQoHGKsa5L+usIChTMm63P85N8ZGofcllE4Hybf7itA=";
      };

      # TODO:
      source.dirs."vendor/xiaomi/socrates".src = pkgs.fetchFromGitHub {
        owner = "kmiit";
        repo = "android_vendor_xiaomi_socrates";
        rev = "";
        hash = "";
      };
    });
  };
}
