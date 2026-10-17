{ config, ... }:
let
  url = "https://${config.nas}:2586/coprime-jyafcofcvwitivpxyvgnkeko";
in
{
  flake.modules.nixos.ntfy =
    { config, pkgs, ... }:
    {
      systemd.services."notify-failure@" = {
        serviceConfig = {
          Type = "oneshot";
          DynamicUser = true;
          SupplementaryGroups = "systemd-journal";
        };
        scriptArgs = "%i";
        script = ''
          journalctl -u "$1" -n 20 --no-pager -o cat |
            ${pkgs.curl}/bin/curl -fsS -m 10 -H "Title: ${config.networking.hostName}: $1 failed" -H "Priority: high" -H "Tags: warning" \
              --data-binary @- ${url}
        '';
      };
      systemd.packages = [
        (pkgs.writeTextDir "lib/systemd/system/service.d/10-notify.conf" "[Unit]\nOnFailure=notify-failure@%n.service\n")
        (pkgs.writeTextDir "lib/systemd/system/notify-failure@.service.d/10-notify.conf" "[Unit]\nOnFailure=\n")
      ];
    };

  flake.modules.homeManager.ntfy =
    { pkgs, ... }:
    {
      systemd.user.services.ntfy = {
        Unit = {
          Description = "ntfy notifications";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.ntfy-sh}/bin/ntfy subscribe ${url} ${pkgs.writeShellScript "ntfy-notify" ''
            ${pkgs.libnotify}/bin/notify-send -a ntfy "''${t:-ntfy}" "$m"
          ''}";
          Restart = "always";
          RestartSec = 10;
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
}
