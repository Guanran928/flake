{
  lib,
  pkgs,
  config,
  ...
}: {
  programs.vscode = lib.mkMerge [
    {
      enable = true;
      package = pkgs.vscodium.override {
        commandLineArgs = ''--password-store="gnome"'';
      };
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
        editor.lineNumbers = "relative";
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
        gitlens.showWelcomeOnInstall = false;
        gitlens.showWhatsNewAfterUpgrades = false;
        gitlens.plusFeatures.enabled = false;
        gitlens.telemetry.enabled = false;
      };
      extensions = with pkgs.vscode-extensions; [
        ### QoL
        eamodio.gitlens
        esbenp.prettier-vscode
        ritwickdey.liveserver
        vscodevim.vim
      ];
    }

    (lib.mkIf (config.myFlake.home-manager.colorScheme == "tokyonight") {
      extensions = [pkgs.vscode-extensions.enkia.tokyo-night];
      userSettings.workbench.colorTheme = "Tokyo Night";
    })
  ];
}
