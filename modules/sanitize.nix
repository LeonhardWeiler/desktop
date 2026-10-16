{
  flake.modules.homeManager.sanitize =
    { lib, pkgs, ... }:
    let
      sanitize = pkgs.writeShellApplication {
        name = "sanitize";
        runtimeInputs = with pkgs; [
          file
          exiftool
          mat2
          ffmpeg
        ];
        bashOptions = [ "nounset" ];
        text = builtins.readFile ./sanitize/sanitize;
      };
      clipboard_sanitize = pkgs.writeShellApplication {
        name = "clipboard_sanitize";
        runtimeInputs = [
          sanitize
          pkgs.wl-clipboard
        ];
        bashOptions = [ "nounset" ];
        text = builtins.readFile ./sanitize/clipboard_sanitize;
      };
    in
    {
      home.packages = [
        sanitize
        clipboard_sanitize
      ];
      xdg.configFile."autostart/clipboard_sanitize.desktop".text = lib.generators.toINI { } {
        "Desktop Entry" = {
          Type = "Application";
          Name = "Clipboard sanitize";
          Comment = "Strip metadata from images passing through the clipboard";
          Exec = "${clipboard_sanitize}/bin/clipboard_sanitize";
          Terminal = false;
          X-GNOME-Autostart-enabled = true;
          OnlyShowIn = "KDE;";
        };
      };
    };
}
