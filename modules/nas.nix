{
  flake.modules.nixos.nas =
    { config, ... }:
    {
      fileSystems = builtins.listToAttrs (
        map
          (s: {
            name = "/mnt/nas/${s}";
            value = {
              device = "//100.65.0.90/${s}";
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
                "uid=1000"
                "gid=100"
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
