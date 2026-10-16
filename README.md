# desktop

NixOS config for my Lenovo Legion 5 Pro: KDE Plasma, btrfs, Colemak DH.
Each file in `modules/` is one feature.

## Use

```sh
rebuild    # apply the config
update     # update inputs, rebuild, commit and push flake.lock
nix fmt    # format
```

Secrets live in `modules/secrets.yaml`, edit with `sops modules/secrets.yaml`.
The age key is in Bitwarden as `sops-age`.

## Install

1. Remove the old `legion` machine in the [Tailscale admin console](https://login.tailscale.com/admin/machines).
2. Boot the [minimal NixOS ISO](https://nixos.org/download/#nixos-iso) from a stick (F12; if it fails, turn off Secure Boot with F2).
3. Run `nmtui` to connect to WiFi, then run:
   ```sh
   bash <(curl -L coprime.tech/legion)
   ```
   Answer `yes`, set the password, pull the stick when the screen goes black.
4. Log in as `leo`, connect to WiFi. `restore` runs on its own and brings back `~` from the NAS.
5. Log in to the Bitwarden app, server `https://nas.taild9564d.ts.net:8443`.

## Backups

- Hourly btrfs snapshots of `/home` in `/mnt/btrfs/snapshots`.
- Daily restic to the NAS: `sudo restic-nas snapshots`, `sudo restic-nas restore latest --target /tmp/restore`.

Games on the RTX 3070: Steam launch option `nvidia-offload %command%`.
