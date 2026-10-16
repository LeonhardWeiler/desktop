{ config, ... }:
let
  inherit (config) user;
in
{
  flake.modules.nixos.backup =
    { config, ... }:
    let
      home = config.users.users.${user}.home;
    in
    {
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

      systemd.services.restic-backups-nas.unitConfig.RequiresMountsFor = "/mnt/nas/leonhard-files";
      services.restic.backups.nas = {
        repository = "/mnt/nas/leonhard-files/restic/${config.networking.hostName}";
        passwordFile = config.sops.secrets.restic.path;
        initialize = true;
        paths = [
          home
          "/var/lib/bluetooth"
          "/etc/NetworkManager/system-connections"
        ];
        exclude = [
          "${home}/.cache"
          "${home}/.local/share/Steam"
          "${home}/.local/share/go"
          "${home}/.local/share/voxtype/models"
          "**/node_modules"
        ];
        extraBackupArgs = [ "--exclude-caches" ];
        checkOpts = [ "--read-data-subset=5%" ];
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };
        pruneOpts = [
          "--group-by paths"
          "--keep-daily 7"
          "--keep-weekly 8"
          "--keep-monthly 12"
        ];
      };
    };
}
