{ config, ... }:
let
  inherit (config) user;
in
{
  flake.modules.nixos.ntfy =
    { config, pkgs, ... }:
    {
      sops.templates."ntfy.yml" = {
        owner = user;
        content = builtins.toJSON {
          subscribe = [
            {
              topic = config.sops.placeholder.ntfy;
              command = ''${pkgs.libnotify}/bin/notify-send -a ntfy "''${t:-ntfy}" "$m"'';
            }
          ];
        };
      };
    };

  flake.modules.homeManager.ntfy =
    { osConfig, pkgs, ... }:
    {
      systemd.user.services.ntfy = {
        Unit = {
          Description = "ntfy notifications";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.ntfy-sh}/bin/ntfy subscribe --config ${
            osConfig.sops.templates."ntfy.yml".path
          } --from-config";
          Restart = "always";
          RestartSec = 10;
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
}
