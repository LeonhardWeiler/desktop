# desktop

NixOS config for my Lenovo Legion 5 Pro 16ARH7H: KDE Plasma, btrfs, Colemak DH.

- `modules/`: flake-parts modules, loaded by import-tree. Each file adds features to `flake.modules.nixos` and `flake.modules.homeManager`; `arch.nix` builds the host from all of them, `home.nix` hands the home modules to home-manager with plasma-manager.
- `modules/disko.nix`: btrfs with subvolumes `root`, `home`, `nix`, `snapshots`.
- `home/`: old dotfiles, no longer linked. Removed after the switch.
- `modules/mixxx/skin/`: recolors the LateNight skin, built into the Nix store.
- `pkgs/`: Helium and eitype, which nixpkgs does not have.

```sh
sudo nixos-rebuild switch --flake ~/files/repos/desktop#arch
nix flake update   # then rebuild
```

## Secrets

`modules/secrets.yaml` is encrypted with sops for the age key in `~/.config/sops/age/keys.txt`,
also in Bitwarden as item `sops-age`. Edit with `sops modules/secrets.yaml`.
The secrets are decrypted to `/run/secrets` at boot and as soon as the key exists.
`~/.ssh` comes back with the restore.

## Install

Before: remove the old `arch` machine in the [Tailscale admin console](https://login.tailscale.com/admin/machines).

1. Plug the stick directly into the laptop, power on, press F12 and pick the stick.
   If it does not boot, turn off Secure Boot in the BIOS (F2).
2. In the live system connect to WiFi in the panel. The keyboard is US QWERTY there. Open Konsole:
   ```sh
   sudo nix --experimental-features 'nix-command flakes' run github:nix-community/disko/latest -- \
     --mode destroy,format,mount --flake github:LeonhardWeiler/desktop#arch
   sudo nixos-install --no-root-passwd --flake github:LeonhardWeiler/desktop#arch
   sudo nixos-enter --root /mnt -c 'passwd leo'
   reboot
   ```
   disko asks before it wipes the SSD, answer `yes`. The install takes 20 to 60 minutes.
   `passwd` sets the login password and already uses Colemak DH. Pull the stick when the screen goes black.
3. Log in as `leo` and connect to WiFi. `restore` starts on its own:
   - asks for the Bitwarden master password while Helium opens the Tailscale login,
   - restores `~` from the latest restic snapshot with a progress bar and reboots.

   It runs on every login until `~/files/repos/desktop` exists.
   If it fails, run `restore` in a terminal to see why.
4. Log in to the Bitwarden desktop app once, server `https://nas.taild9564d.ts.net:8443`.
   Everything else comes back with `~`.

## Backups

- Hourly btrfs snapshots of `/home` in `/mnt/btrfs/snapshots`. Restore a file with `cp`.
- Daily restic of `~`, `/var/lib` and the WiFi connections to the NAS (`/mnt/nas/leonhard-files/restic/arch`):
  `sudo restic-nas snapshots`, `sudo restic-nas restore latest --target /tmp/restore`.
  After a reinstall, bring back WiFi and Bluetooth with
  `sudo restic-nas restore latest --target / --include /var/lib/bluetooth --include /etc/NetworkManager/system-connections`.
- Games on the RTX 3070: Steam launch option `nvidia-offload %command%`.
