{
  flake.modules.homeManager.ntfy =
    { pkgs, ... }:
    {
      xdg.configFile."ntfy/client.yml".text = builtins.toJSON {
        subscribe = [
          {
            topic = "coprime-t356nf2edd7dthaxgnya";
            command = ''${pkgs.libnotify}/bin/notify-send -a ntfy "''${t:-ntfy}" "$m"'';
          }
        ];
      };
      systemd.user.services.ntfy = {
        Unit = {
          Description = "ntfy notifications";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.ntfy-sh}/bin/ntfy subscribe --from-config";
          Restart = "always";
          RestartSec = 10;
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
}
