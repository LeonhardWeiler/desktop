{
  flake.modules.homeManager.claude = {
    programs.claude-code = {
      enable = true;
      mutableSettings = true;
      context = ./claude/CLAUDE.md;
      skills = ./claude/skills;
      settings = {
        permissions = {
          defaultMode = "auto";
          additionalDirectories = [ "/" ];
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
