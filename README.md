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

Not in the repo, copy them by hand as root with mode 600. A copy is in `/mnt/nas/leonhard-files/archive/backup/arch-2026-10-15/etc.tar`:

- `/etc/samba/credentials/share-<share>`: `username=…` and `password=…`
- `/etc/restic/password`: the restic password, nothing else
- `/etc/NetworkManager/system-connections/`: WiFi
- `~/.ssh/id_ed25519`

## Install

1. Boot the NixOS graphical ISO and connect to WiFi.
2. Partition (wipes the whole SSD) and install:
   ```sh
   sudo nix --experimental-features 'nix-command flakes' run github:nix-community/disko/latest -- \
     --mode destroy,format,mount --flake github:leonhardweiler/desktop#arch
   sudo nixos-install --no-root-passwd --flake github:leonhardweiler/desktop#arch
   sudo nixos-enter --root /mnt -c 'passwd leo'
   ```
3. Copy the secrets to `/mnt/etc/…` and `/mnt/home/leo/.ssh`, then reboot.
4. `git clone git@github.com:leonhardweiler/desktop ~/files/repos/desktop`, log out and in again.
5. Log in once: `tailscale up`, `claude`, `gh auth login`, Bitwarden (server `https://nas.taild9564d.ts.net:8443`), Helium.

## Backups

- Hourly btrfs snapshots of `/home` in `/mnt/btrfs/snapshots`. Restore a file with `cp`.
- Daily restic to the NAS (`/mnt/nas/leonhard-files/restic/arch`):
  `sudo restic-nas snapshots`, `sudo restic-nas restore latest --target /tmp/restore`.
- Games on the RTX 3070: Steam launch option `nvidia-offload %command%`.
