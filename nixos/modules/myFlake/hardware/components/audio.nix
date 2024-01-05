{
  lib,
  config,
  ...
}: let
  cfg = config.myFlake.hardware.components.audio;
in {
  options = {
    myFlake.hardware.components.audio.enable = lib.mkEnableOption "Whether to enable audio.";
    myFlake.hardware.components.audio.soundServer = lib.mkOption {
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

        # pipewireLowLatency module from github:fufexan/nix-gaming
        lowLatency.enable = true;
      };
    })
    (lib.mkIf (cfg.soundServer == "pulseaudio") {
      hardware.pulseaudio.enable = true;
      hardware.pulseaudio.support32Bit = true;
    })
  ]);
}
