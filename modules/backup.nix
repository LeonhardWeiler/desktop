{ config, ... }:
let
  inherit (config) user nas;
in
{
  flake.modules.nixos.backup =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      home = config.users.users.${user}.home;
      exclude = [
        "${home}/.cache"
        "${home}/.local/share/go"
        "${home}/.local/share/voxtype/models"
        "node_modules"
      ];
    in
    {
      sops.secrets.backup.key = "backup/${config.networking.hostName}";

      services.btrbk.instances.home = {
        onCalendar = "hourly";
        settings = {
          timestamp_format = "long";
          snapshot_preserve_min = "2h";
          snapshot_preserve = "48h 14d 8w";
          volume."/mnt/btrfs" = {
            snapshot_dir = "snapshots";
            subvolume.home = { };
          };
        };
      };

      systemd.services.backup = {
        wants = [ "network-online.target" ];
        after = [
          "network-online.target"
          "tailscaled.service"
        ];
        startAt = "daily";
        path = [
          pkgs.rsync
          pkgs.openssh
          pkgs.util-linux
        ];
        environment = {
          PATHS = "${home} /var/lib/bluetooth /etc/NetworkManager/system-connections";
          RSYNC_RSH = "ssh -F none -i ${config.sops.secrets.backup.path}";
          REMOTE = "root@${nas}";
        };
        startLimitBurst = 6;
        startLimitIntervalSec = 3600;
        serviceConfig = {
          Type = "oneshot";
          Restart = "on-failure";
          RestartSec = "5min";
          PrivateMounts = true;
        };
        script = ''
          snaps=(/mnt/btrfs/snapshots/home.*)
          mount --bind "''${snaps[-1]}" /home
          rsync -a --info=name1,stats2 --relative --numeric-ids -M--fake-super --delete --delete-excluded \
            ${lib.concatMapStringsSep " " (e: "--exclude=${e}") exclude} $PATHS "$REMOTE:." || [ $? = 24 ]
        '';
      };
      systemd.timers.backup.timerConfig.Persistent = true;
    };
}
