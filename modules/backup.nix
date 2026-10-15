{
  flake.modules.nixos.backup = {
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

    services.restic.backups.nas = {
      repository = "/mnt/nas/leonhard-files/restic/arch";
      passwordFile = "/home/leo/.config/restic/password";
      initialize = true;
      paths = [
        "/home/leo"
        "/var/lib"
        "/etc/NetworkManager/system-connections"
      ];
      exclude = [
        "/home/leo/.cache"
        "/var/lib/docker"
        "/home/leo/.local/share/Steam"
        "/home/leo/go"
        "/home/leo/.local/share/go"
        "/home/leo/.local/share/voxtype/models"
        "/home/leo/.npm"
        "**/node_modules"
        "**/target"
        "**/result"
      ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 8"
        "--keep-monthly 12"
      ];
    };
  };
}
