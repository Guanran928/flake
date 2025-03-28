{ pkgs, lib, ... }:
{
  programs.mpv = {
    enable = true;
    config = {
      ao = "pipewire";
      # FIXME: freezes the entire WM
      # vo = "gpu-next";
      # FIXME: using VAAPI sometimes can cause address boundary error
      # hwdec = "auto-safe";
      profile = "high-quality";

      alang = "jpn,ja";
      slang = "eng,en";

      osc = "no";
    };

    scripts =
      (with pkgs.mpvScripts; [
        modernz
        thumbfast
      ])
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux (with pkgs.mpvScripts; [ mpris ]);

    bindings =
      let
        inherit (pkgs) anime4k;
        setShader =
          message: files:
          ''no-osd change-list glsl-shaders set "${lib.concatStringsSep ":" files}"; show-text "${message}"'';
      in
      {
        "CTRL+1" = setShader "Anime4K: Mode A (Fast)" [
          "${anime4k}/Anime4K_Clamp_Highlights.glsl"
          "${anime4k}/Anime4K_Restore_CNN_M.glsl"
          "${anime4k}/Anime4K_Upscale_CNN_x2_M.glsl"
          "${anime4k}/Anime4K_AutoDownscalePre_x2.glsl"
          "${anime4k}/Anime4K_AutoDownscalePre_x4.glsl"
          "${anime4k}/Anime4K_Upscale_CNN_x2_S.glsl"
        ];
        "CTRL+2" = setShader "Anime4K: Mode B (Fast)" [
          "${anime4k}/Anime4K_Clamp_Highlights.glsl"
          "${anime4k}/Anime4K_Restore_CNN_Soft_M.glsl"
          "${anime4k}/Anime4K_Upscale_CNN_x2_M.glsl"
          "${anime4k}/Anime4K_AutoDownscalePre_x2.glsl"
          "${anime4k}/Anime4K_AutoDownscalePre_x4.glsl"
          "${anime4k}/Anime4K_Upscale_CNN_x2_S.glsl"
        ];
        "CTRL+3" = setShader "Anime4K: Mode C (Fast)" [
          "${anime4k}/Anime4K_Clamp_Highlights.glsl"
          "${anime4k}/Anime4K_Upscale_Denoise_CNN_x2_M.glsl"
          "${anime4k}/Anime4K_AutoDownscalePre_x2.glsl"
          "${anime4k}/Anime4K_AutoDownscalePre_x4.glsl"
          "${anime4k}/Anime4K_Upscale_CNN_x2_S.glsl"
        ];
        "CTRL+4" = setShader "Anime4K: Mode A+A (Fast)" [
          "${anime4k}/Anime4K_Clamp_Highlights.glsl"
          "${anime4k}/Anime4K_Restore_CNN_M.glsl"
          "${anime4k}/Anime4K_Upscale_CNN_x2_M.glsl"
          "${anime4k}/Anime4K_Restore_CNN_S.glsl"
          "${anime4k}/Anime4K_AutoDownscalePre_x2.glsl"
          "${anime4k}/Anime4K_AutoDownscalePre_x4.glsl"
          "${anime4k}/Anime4K_Upscale_CNN_x2_S.glsl"
        ];
        "CTRL+5" = setShader "Anime4K: Mode B+B (Fast)" [
          "${anime4k}/Anime4K_Clamp_Highlights.glsl"
          "${anime4k}/Anime4K_Restore_CNN_Soft_M.glsl"
          "${anime4k}/Anime4K_Upscale_CNN_x2_M.glsl"
          "${anime4k}/Anime4K_AutoDownscalePre_x2.glsl"
          "${anime4k}/Anime4K_AutoDownscalePre_x4.glsl"
          "${anime4k}/Anime4K_Restore_CNN_Soft_S.glsl"
          "${anime4k}/Anime4K_Upscale_CNN_x2_S.glsl"
        ];
        "CTRL+6" = setShader "Anime4K: Mode C+A (Fast)" [
          "${anime4k}/Anime4K_Clamp_Highlights.glsl"
          "${anime4k}/Anime4K_Upscale_Denoise_CNN_x2_M.glsl"
          "${anime4k}/Anime4K_AutoDownscalePre_x2.glsl"
          "${anime4k}/Anime4K_AutoDownscalePre_x4.glsl"
          "${anime4k}/Anime4K_Restore_CNN_S.glsl"
          "${anime4k}/Anime4K_Upscale_CNN_x2_S.glsl"
        ];

        "CTRL+0" = ''no-osd change-list glsl-shaders clr ""; show-text "GLSL shaders cleared"'';
      };
  };
}
