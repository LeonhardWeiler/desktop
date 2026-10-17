{ config, ... }:
let
  inherit (config) user;
in
{
  flake.modules.nixos.ntfy =
    { config, pkgs, ... }:
    {
      sops.secrets.ntfy = { };
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

      systemd.services."notify-failure@" = {
        serviceConfig = {
          Type = "oneshot";
          DynamicUser = true;
          SupplementaryGroups = "systemd-journal";
          LoadCredential = "topic:${config.sops.secrets.ntfy.path}";
        };
        scriptArgs = "%i";
        script = ''
          journalctl -u "$1" -n 20 --no-pager -o cat |
            ${pkgs.curl}/bin/curl -fsS -m 10 -H "Title: ${config.networking.hostName}: $1 failed" -H "Priority: high" -H "Tags: warning" \
              --data-binary @- "https://ntfy.sh/$(cat "$CREDENTIALS_DIRECTORY/topic")"
        '';
      };
      systemd.packages = [
        (pkgs.writeTextDir "lib/systemd/system/service.d/10-notify.conf" "[Unit]\nOnFailure=notify-failure@%n.service\n")
        (pkgs.writeTextDir "lib/systemd/system/notify-failure@.service.d/10-notify.conf" "[Unit]\nOnFailure=\n")
      ];
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
