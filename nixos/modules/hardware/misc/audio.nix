{
  lib,
  config,
  ...
}: let
  cfg = config.myFlake.nixos.hardware.misc.audio;
in {
  options = {
    myFlake.nixos.hardware.misc.audio.enable = lib.mkEnableOption "Whether to enable audio.";
    myFlake.nixos.hardware.misc.audio.soundServer = lib.mkOption {
      type = lib.types.enum ["pipewire" "pulseaudio"];
      default = "pipewire";
      example = "pulseaudio";
      description = "Select desired sound system.";
    };
  };

  # https://nixos.wiki/wiki/PipeWire
  # https://nixos.wiki/wiki/PulseAudio
  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf (cfg.soundServer == "pipewire") {
      security.rtkit.enable = true;
      hardware.pulseaudio.enable = false;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };
    })
    (lib.mkIf (cfg.soundServer == "pulseaudio") {
      hardware.pulseaudio.enable = true;
      hardware.pulseaudio.support32Bit = true;
    })
  ]);
}
