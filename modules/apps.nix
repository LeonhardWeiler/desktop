{
  flake.modules.homeManager.apps =
    { lib, pkgs, ... }:
    {
      xdg.mimeApps = {
        enable = true;
        associations.added = {
          "text/markdown" = [
            "okularApplication_md.desktop"
            "okularApplication_txt.desktop"
            "nvim.desktop"
          ];
          "text/vnd.typst" = [
            "nvim.desktop"
            "okularApplication_txt.desktop"
          ];
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
            "x-scheme-handler/sgnl" = "signal.desktop";
            "x-scheme-handler/signalcaptcha" = "signal.desktop";
            "x-scheme-handler/t3code" = "t3code.desktop";
            "x-scheme-handler/bitwarden" = "bitwarden.desktop";
          };
      };

      xdg.configFile."autostart/bitwarden.desktop" = {
        force = true;
        text = lib.generators.toINI { } {
          "Desktop Entry" = {
            Type = "Application";
            Name = "Bitwarden";
            Exec = "bitwarden --autostart";
            StartupNotify = false;
            Terminal = false;
          };
        };
      };

      programs.codex.enable = true;
      home.packages = [ pkgs.t3code ];
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
          MimeType = "x-scheme-handler/t3code;";
        };
      };
    };
}
