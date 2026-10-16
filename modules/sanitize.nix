{
  flake.modules.homeManager.sanitize =
    { lib, pkgs, ... }:
    let
      sanitize = pkgs.runCommand "sanitize" { } "mkdir $out && cp -r ${./sanitize} $out/bin";
    in
    {
      home.packages = [ sanitize ];
      xdg.configFile."autostart/clipboard_sanitize.desktop".text = lib.generators.toINI { } {
        "Desktop Entry" = {
          Type = "Application";
          Name = "Clipboard sanitize";
          Comment = "Strip metadata from images passing through the clipboard";
          Exec = "${sanitize}/bin/clipboard_sanitize";
          Terminal = false;
          X-GNOME-Autostart-enabled = true;
          OnlyShowIn = "KDE;";
        };
      };
    };
}
