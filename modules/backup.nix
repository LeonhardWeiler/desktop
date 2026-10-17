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
        "${home}/.local/share/Steam"
        "${home}/.local/share/go"
        "${home}/.local/share/voxtype/models"
        "node_modules"
      ];
    in
    {
      sops.secrets.backup = { };

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
        ];
        environment = {
          PATHS = "${home} /var/lib/bluetooth /etc/NetworkManager/system-connections";
          RSYNC_RSH = "ssh -F none -i ${config.sops.secrets.backup.path}";
          REMOTE = "root@${nas}";
        };
        serviceConfig.Type = "oneshot";
        script = ''
          rsync -a --relative --numeric-ids -M--fake-super --delete --delete-excluded \
            ${lib.concatMapStringsSep " " (e: "--exclude=${e}") exclude} $PATHS "$REMOTE:/" || [ $? = 24 ]
        '';
      };
      systemd.timers.backup.timerConfig.Persistent = true;
    };
}
