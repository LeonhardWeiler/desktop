{ config, ... }:
let
  inherit (config) user;
in
{
  flake.modules.nixos.nas =
    { config, ... }:
    {
      fileSystems = builtins.listToAttrs (
        map
          (s: {
            name = "/mnt/nas/${s}";
            value = {
              device = "//nas.taild9564d.ts.net/${s}";
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
    };
}
