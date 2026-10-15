# desktop

NixOS config for my Lenovo Legion 5 Pro 16ARH7H: KDE Plasma, btrfs, Colemak DH.

- `configuration.nix`: system, programs, NAS shares, backups, dotfile links.
- `disko.nix`: btrfs with subvolumes `root`, `home`, `nix`, `snapshots`.
- `home/`: dotfiles. Each path in `links` in `configuration.nix` is symlinked into `~`, so edits apply without a rebuild.
- `pkgs/`: Helium and eitype, which nixpkgs does not have.

```sh
sudo nixos-rebuild switch --flake ~/files/repos/desktop#arch
nix flake update   # then rebuild
```

## Secrets

Not in the repo. They live in `~` and come back with the restore:

- `~/.config/nas/<share>`: `username=…` and `password=…`
- `~/.config/restic/password`, also in Bitwarden as item `restic`
- `~/.ssh`

## Install

1. Remove the old `arch` machine in the Tailscale admin console.
2. Boot the NixOS graphical ISO and connect to WiFi.
3. Partition (wipes the whole SSD) and install:
   ```sh
   sudo nix --experimental-features 'nix-command flakes' run github:nix-community/disko/latest -- \
     --mode destroy,format,mount --flake github:leonhardweiler/desktop#arch
   sudo nixos-install --no-root-passwd --flake github:leonhardweiler/desktop#arch
   sudo nixos-enter --root /mnt -c 'passwd leo'
   ```
4. Reboot, log in and connect to WiFi. `restore` asks for the Bitwarden password,
   opens the Tailscale login, asks for the NAS password, restores `~` from the
   latest restic snapshot and reboots. It runs on every login until
   `~/files/repos/desktop` exists.

## Backups

- Hourly btrfs snapshots of `/home` in `/mnt/btrfs/snapshots`. Restore a file with `cp`.
- Daily restic to the NAS (`/mnt/nas/leonhard-files/restic/arch`):
  `sudo restic-nas snapshots`, `sudo restic-nas restore latest --target /tmp/restore`.
- Games on the RTX 3070: Steam launch option `nvidia-offload %command%`.
