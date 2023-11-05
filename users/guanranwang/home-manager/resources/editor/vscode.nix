{
  lib,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium; # foss
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    userSettings = {
      "diffEditor.ignoreTrimWhitespace" = false;
      "editor.cursorBlinking" = "smooth";
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.fontFamily" = lib.mkDefault "Monospace";
      "editor.fontWeight" = 600;
      "editor.tabSize" = 2;
      "explorer.confirmDragAndDrop" = false;
      "explorer.confirmDelete" = false;
      "files.autoSave" = "onFocusChange";
      "files.trimTrailingWhitespace" = true;
      "files.trimFinalNewlines" = true;
      "security.workspace.trust.enabled" = false;
      "telemetry.telemetryLevel" = "off";
      "terminal.external.osxExec" = "Alacritty.app";
      "terminal.integrated.cursorBlinking" = true;
      "update.mode" = "none";
      "window.menuBarVisibility" = "toggle";
      "workbench.colorTheme" = "Tokyo Night";

      # Extensions
      ### Nix IDE
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nil}/bin/nil";
      ### GitLens
      "gitlens.telemetry.enabled" = false;
    };
    extensions = with pkgs.vscode-extensions; [
      ### LSP
      jnoortheen.nix-ide
      #ms-python.python
      rust-lang.rust-analyzer
      tamasfe.even-better-toml
      #bungcip.better-toml

      ### QoL
      eamodio.gitlens
      esbenp.prettier-vscode
      ritwickdey.liveserver
      vscodevim.vim

      ### Themes
      enkia.tokyo-night
      #catppuccin.catppuccin-vsc-icons
      #catppuccin.catppuccin-vsc
    ];
  };
}
