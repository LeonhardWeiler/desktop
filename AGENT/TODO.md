# TODO

1. LUKS and Secure Boot: encrypt the btrfs partition in `disko.nix` (LUKS, unlocked via TPM2 with
   `systemd-cryptenroll`), sign the boot chain with lanzaboote. Needs a reinstall with `install.sh` and `restore`.
   TPM2 unlock needs `boot.initrd.systemd.enable = true` and `security.tpm2.enable = true`; `bootctl` currently
   reports `TPM2 Support: no`.
2. Manually maintained packages: `helium` (AppImage overlay in `helium.nix`) and `eitype` (in `voxtype.nix`)
   are not in nixpkgs and `update` does not bump them. Helium had 8 releases in 4 weeks. Package them in nixpkgs,
   then use `pkgs.helium` and `pkgs.eitype`.
   - A Helium package must keep `--ro-bind-try /etc/chromium /etc/chromium` in bwrap, otherwise the
     `programs.chromium` policies from `helium.nix` do not reach the browser.
3. NAS (`ssh nas`, each connection needs a confirm click by the user):
   - Write the new ntfy topic (`sudo cat /run/secrets/ntfy`) to `/var/lib/nas/ntfy-topic` on the NAS.
   - Serve restic via `restic-rest-server --append-only` over Tailscale instead of the CIFS share
     and point `services.restic.backups.nas.repository` in `backup.nix` at `rest:http://nas:8000/legion`.
     Today the CIFS share is mounted rw as leo (`uid=leo`, `0775`),
     so any process of leo can delete the repository; only the NAS btrbk snapshots and `/mnt/backup` protect it.
4. Self-host ntfy on the NAS (`services.ntfy-sh`, reachable only over Tailscale) instead of ntfy.sh, and switch
   both the laptop (`ntfy.nix`, the `ntfy` secret) and the server (`~/files/school/HTL4/waentw/server-config`) to it.
5. t3code desktop entry: the nixpkgs package ships `t3code.desktop` without `MimeType=x-scheme-handler/t3code;`
   and with `StartupWMClass=t3code` instead of `com.t3tools.T3Code`. Fix it in nixpkgs (PR), then drop the
   `xdg.dataFile."applications/t3code.desktop"` override in `apps.nix`.
6. Old age key copies: until 2026-10-17 the age key lived in `~/.config/sops/age/keys.txt`, so it is in the btrbk
   snapshots of `/home` (expire after 8 weeks) and in the restic snapshots (up to 12 months), both readable by leo.
   With it the old revisions of `secrets.yaml` in git decrypt to the current values. After item 3, rotate the
   secrets themselves (restic password, NAS SMB credentials, ntfy topic), then the age key (`age-keygen`, new
   recipient in `.sops.yaml`, `sudo sops updatekeys modules/secrets.yaml`, new `sops-age` in Bitwarden).
7. `restore.sh` is only checked with shellcheck, never run end to end (Bitwarden login, age key install via sudo,
   restic as root, marker). Run it on the reinstall of item 1 and fix what breaks.
