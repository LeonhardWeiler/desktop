{ config, ... }:
let
  inherit (config) user;
in
{
  flake.modules.nixos.school =
    { config, ... }:
    {
      sops.secrets."school/medt" = { };
      fileSystems."/mnt/school/MEDT" = {
        device = "//htl-ssd-storage01.htl-vil.local/MEDT";
        fsType = "cifs";
        options = [
          "noauto"
          "x-systemd.automount"
          "x-systemd.mount-timeout=15"
          "_netdev"
          "nofail"
          "soft"
          "credentials=${config.sops.secrets."school/medt".path}"
          "uid=${user}"
          "gid=users"
          "file_mode=0664"
          "dir_mode=0775"
          "iocharset=utf8"
          "nobrl"
        ];
      };
    };
}
