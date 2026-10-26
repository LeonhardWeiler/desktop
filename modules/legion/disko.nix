{ inputs, ... }:
{
  flake.modules.nixos.legion = {
    imports = [ inputs.disko.nixosModules.disko ];
    disko.devices.disk.ssd = {
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              mountpoint = "/mnt/btrfs";
              subvolumes =
                let
                  opts = [
                    "compress=zstd"
                    "noatime"
                  ];
                in
                {
                  root = {
                    mountpoint = "/";
                    mountOptions = opts;
                  };
                  home = {
                    mountpoint = "/home";
                    mountOptions = opts;
                  };
                  nix = {
                    mountpoint = "/nix";
                    mountOptions = opts;
                  };
                  snapshots = { };
                };
            };
          };
        };
      };
    };
  };
}
