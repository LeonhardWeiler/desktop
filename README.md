# desktop

NixOS config for my machines: KDE Plasma, btrfs, Colemak DH.
Each file in `modules/` is one feature, shared by all hosts.
`modules/<host>/` holds what only one host gets.

| Host     | Machine                           |
| -------- | --------------------------------- |
| `legion` | Lenovo Legion 5 Pro laptop        |
| `pc`     | Desktop PC, i5-11500, RTX 3070    |

## Use

```sh
rebuild          # git pull, apply the config
update           # git pull, update inputs, commit flake.lock, rebuild and push
nix fmt          # format
nix flake check  # build all hosts
```

Secrets live in `modules/secrets.yaml`, edit with `sudo sops modules/secrets.yaml`.
Each host has its own age key, in Bitwarden as `sops-age-<host>`.

## Install

1. Remove the old machine in the [Tailscale admin console](https://login.tailscale.com/admin/machines), otherwise the new one is named e.g. `legion-1`.
2. Boot the [minimal NixOS ISO](https://nixos.org/download/#nixos-iso) from a stick (F12; if it fails, turn off Secure Boot with F2).
3. Run `nmtui` to connect to WiFi, then run:
   ```sh
   bash <(curl -L coprime.tech/desktop) <host>
   ```
4. Log in as `leo`, connect to WiFi. `restore` runs on its own, asks for the Bitwarden master password and the password of `leo`, brings back `~`, WiFi and Bluetooth from the NAS and restarts.
5. Log in to the Bitwarden app, server `https://nas.taild9564d.ts.net:8443`.

### From another machine with nixos-anywhere

The other machine must reach the laptop over SSH, e.g. in the same WiFi, and needs Nix:

- Linux and macOS: `sh <(curl -L https://nixos.org/nix/install) --daemon`, then open a new terminal.
- Windows: `wsl --install` in PowerShell, reboot, open Ubuntu and run the Linux command there.

1. Boot any Linux on the laptop, e.g. the minimal NixOS ISO, and connect to the internet.
   Make sure SSH login works (on the NixOS ISO run `passwd`) and note the IP from `ip a`.
2. On the other machine run this, enter `user@ip` and that user's password, then set the password for `leo`:
   ```sh
   bash <(curl -L coprime.tech/desktop-anywhere) <host>
   ```
3. Continue with step 4 above.

## Backups

- Hourly btrfs snapshots of `/home` in `/mnt/btrfs/snapshots`.
- Daily rsync mirror of the latest snapshot to `leonhard-files/backup/<host>` on the NAS, history in the NAS snapshots: `sudo systemctl start backup`.
