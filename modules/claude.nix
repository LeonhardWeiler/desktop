{
  flake.modules.homeManager.claude =
    { config, lib, ... }:
    {
      xdg.mimeApps.defaultApplications."x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
      xdg.dataFile."applications/claude-code-url-handler.desktop" = {
        force = true;
        text = lib.generators.toINI { } {
          "Desktop Entry" = {
            Name = "Claude Code URL Handler";
            Exec = "${lib.getExe config.programs.claude-code.finalPackage} --handle-uri %u";
            Type = "Application";
            NoDisplay = true;
            MimeType = "x-scheme-handler/claude-cli;";
          };
        };
      };
      programs.claude-code = {
        enable = true;
        mutableSettings = true;
        context = ./claude/CLAUDE.md;
        skills = ./claude/skills;
        settings = {
          permissions = {
            defaultMode = "auto";
            additionalDirectories = [ "/" ];
            deny = map (p: "Read(${p})") [
              "~/.ssh/**"
              "~/.config/sops/**"
              "//run/secrets/**"
              "//run/secrets.d/**"
            ];
          };
          model = "opus";
          disableClaudeAiConnectors = true;
          language = "german";
          effortLevel = "medium";
          autoCompactWindow = 200000;
          promptSuggestionEnabled = false;
          skipDangerousModePermissionPrompt = true;
          theme = "dark";
          env.DISABLE_AUTOUPDATER = "1";
          fileCheckpointingEnabled = false;
          remoteControlAtStartup = false;
          inputNeededNotifEnabled = true;
          agentPushNotifEnabled = true;
        };
      };
    };
}
