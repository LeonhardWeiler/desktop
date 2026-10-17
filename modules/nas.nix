{ config, ... }:
let
  inherit (config) user nas;
in
{
  flake.modules.nixos.nas =
    {
      config,
      lib,
      utils,
      ...
    }:
    lib.mkMerge (
      map
        (s: {
          sops.secrets."nas/${s}" = { };
          systemd.units."${utils.escapeSystemdPath "/mnt/nas/${s}"}.mount" = {
            overrideStrategy = "asDropin";
            text = ''
              [Unit]
              StartLimitIntervalSec=0
            '';
          };
          fileSystems."/mnt/nas/${s}" = {
            device = "//${nas}/${s}";
            fsType = "cifs";
            options = [
              "noauto"
              "x-systemd.automount"
              "x-systemd.mount-timeout=15"
              "x-systemd.device-timeout=15"
              "_netdev"
              "x-systemd.after=tailscaled.service"
              "nofail"
              "soft"
              "credentials=${config.sops.secrets."nas/${s}".path}"
              "uid=${user}"
              "gid=users"
              "file_mode=0664"
              "dir_mode=0775"
              "iocharset=utf8"
              "nobrl"
            ];
          };
        })
        [
          "leonhard-files"
          "shared-files"
          "old-drive"
        ]
    );
}
