{
  flake.modules.homeManager.apps =
    { lib, ... }:
    {
      xdg.mimeApps = {
        enable = true;
        associations.added = {
          "text/markdown" = [
            "dev.zed.Zed.desktop"
            "org.kde.kate.desktop"
            "org.kde.kwrite.desktop"
            "okularApplication_md.desktop"
            "okularApplication_txt.desktop"
            "nvim.desktop"
            "org.kde.ghostwriter.desktop"
            "org.kde.calligrawords_ascii.desktop"
          ];
          "text/vnd.typst" = [
            "dev.zed.Zed.desktop"
            "org.kde.kate.desktop"
            "org.kde.kwrite.desktop"
            "org.kde.ghostwriter.desktop"
            "nvim.desktop"
            "okularApplication_txt.desktop"
            "org.kde.calligrawords_ascii.desktop"
          ];
          "video/mp4" = [
            "mpv.desktop"
            "org.kde.dragonplayer.desktop"
            "org.kde.kdenlive.desktop"
            "org.kde.koko.desktop"
          ];
          "x-scheme-handler/bitwarden" = "bitwarden.desktop";
        };
        defaultApplications =
          lib.genAttrs [
            "application/x-extension-htm"
            "application/x-extension-html"
            "application/x-extension-shtml"
            "application/x-extension-xht"
            "application/x-extension-xhtml"
            "application/xhtml+xml"
            "image/jpeg"
            "text/html"
            "x-scheme-handler/chrome"
            "x-scheme-handler/http"
            "x-scheme-handler/https"
          ] (_: "helium.desktop")
          // {
            "text/markdown" = "dev.zed.Zed.desktop";
            "text/vnd.typst" = "dev.zed.Zed.desktop";
            "video/mp4" = "mpv.desktop";
            "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
            "x-scheme-handler/figma" = "figma-linux.desktop";
            "x-scheme-handler/sgnl" = "signal.desktop";
            "x-scheme-handler/signalcaptcha" = "signal.desktop";
            "x-scheme-handler/t3code" = "com.t3tools.T3Code.desktop";
            "x-scheme-handler/bitwarden" = "bitwarden.desktop";
          };
      };

      xdg.dataFile."applications/t3code.desktop".text = lib.generators.toINI { } {
        "Desktop Entry" = {
          Categories = "Development";
          Comment = "Minimal web GUI for coding agents";
          Exec = "t3code-desktop %U";
          Icon = "t3code";
          Name = "T3 Code (Alpha)";
          StartupWMClass = "com.t3tools.T3Code";
          Terminal = false;
          Type = "Application";
          Version = "1.5";
        };
      };
    };
}
