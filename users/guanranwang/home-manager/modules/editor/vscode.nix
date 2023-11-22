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
    keybindings = [
      {
        key = "tab";
        command = "selectNextSuggestion";
        when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus || suggestWidgetVisible && textInputFocus && !suggestWidgetHasFocusedSuggestion";
      }
      {
        key = "shift+tab";
        command = "selectPrevSuggestion";
        when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus || suggestWidgetVisible && textInputFocus && !suggestWidgetHasFocusedSuggestion";
      }
    ];
    userSettings = {
      diffEditor.ignoreTrimWhitespace = false;
      editor.cursorBlinking = "smooth";
      editor.cursorSmoothCaretAnimation = "on";
      editor.fontFamily = lib.mkDefault "Monospace";
      editor.fontWeight = 600;
      editor.smoothScrolling = true;
      editor.tabSize = 2;
      explorer.confirmDragAndDrop = false;
      explorer.confirmDelete = false;
      files.autoSave = "onFocusChange";
      files.trimTrailingWhitespace = true;
      files.trimFinalNewlines = true;
      security.workspace.trust.enabled = false;
      telemetry.telemetryLevel = "off";
      terminal.integrated.cursorStyle = "line";
      terminal.integrated.smoothScrolling = true;
      window.menuBarVisibility = "toggle";
      workbench.colorTheme = "Tokyo Night";
      workbench.list.smoothScrolling = true;

      # Workaround for VSCode crashing
      # https://github.com/microsoft/vscode/issues/184124
      window.titleBarStyle = "custom";
      workbench.layoutControl.enabled = false;
      window.commandCenter = false;

      # Language specific
      ### Nix
      "[nix]".editor.tabSize = 2;

      # Extensions
      ### GitLens
      gitlens.telemetry.enabled = false;
    };
    extensions = with pkgs.vscode-extensions; [
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
