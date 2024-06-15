{
  lib,
  config,
  ...
}: let
  cfg = config.my.hardware.audio;
in {
  options = {
    my.hardware.audio.enable = lib.mkEnableOption "audio";
  };

  # https://nixos.wiki/wiki/PipeWire
  config = lib.mkIf cfg.enable {
    security.rtkit.enable = true;
    hardware.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
