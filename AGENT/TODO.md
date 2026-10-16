# TODO

1. LUKS and Secure Boot: encrypt the btrfs partition in `disko.nix` (LUKS, unlocked via TPM2 with
   `systemd-cryptenroll`), sign the boot chain with lanzaboote. Needs a reinstall with `install.sh` and `restore`.
2. Manually maintained packages: `helium` (AppImage overlay in `helium.nix`) and `eitype` (in `voxtype.nix`)
   are not in nixpkgs and `update` does not bump them. Package them in nixpkgs, then use `pkgs.helium` and `pkgs.eitype`.
3. NAS (needs `ssh root@nas`, currently denied for the laptop key):
   - Write the new ntfy topic (`sudo cat /run/secrets/ntfy`) to `/var/lib/nas/ntfy-topic` on the NAS.
   - Serve restic via `restic-rest-server --append-only` over Tailscale instead of the CIFS share
     and point `services.restic.backups.nas.repository` in `backup.nix` at `rest:http://nas:8000/legion`.
