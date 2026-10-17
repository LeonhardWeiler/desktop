# TODO

1. LUKS and Secure Boot: encrypt the btrfs partition in `disko.nix` (LUKS, unlocked via TPM2 with
   `systemd-cryptenroll`), sign the boot chain with lanzaboote. Needs a reinstall with `install.sh` and `restore`.
   TPM2 unlock needs `boot.initrd.systemd.enable = true` and `security.tpm2.enable = true`; `bootctl` currently
   reports `TPM2 Support: no`.
2. Manually maintained packages: `helium` (AppImage overlay in `helium.nix`) and `eitype` (in `voxtype.nix`)
   are not in nixpkgs and `update` does not bump them. Helium had 8 releases in 4 weeks. Package them in nixpkgs,
   then use `pkgs.helium` and `pkgs.eitype`.
   - Helium policies: the FHS sandbox hid `/etc/chromium`, so `programs.chromium` policies (extensions,
     `RestoreOnStartup`) and the Bitwarden native messaging host never applied. `helium.nix` now binds
     `/etc/chromium` read-only (untested). After `rebuild`, check `helium://policy` lists
     `ExtensionInstallForcelist`; a nixpkgs package must keep that bind.
3. NAS (needs `ssh root@nas`, currently denied for the laptop key):
   - Deploy the NAS repo: it now authorizes only `~/.ssh/nas.pub` (the confirm-only key `ssh.nix` uses for `nas`)
     for root instead of `leo@arch`.
   - Write the new ntfy topic (`sudo cat /run/secrets/ntfy`) to `/var/lib/nas/ntfy-topic` on the NAS.
   - Serve restic via `restic-rest-server --append-only` over Tailscale instead of the CIFS share
     and point `services.restic.backups.nas.repository` in `backup.nix` at `rest:http://nas:8000/legion`.
     Today the CIFS share is mounted rw as leo (`uid=leo`, `0775`) and the restic password is owned by leo,
     so any process of leo can delete the repository; only the NAS btrbk snapshots and `/mnt/backup` protect it.
4. Self-host ntfy on the NAS (`services.ntfy-sh`, reachable only over Tailscale) instead of ntfy.sh, and switch
   both the laptop (`ntfy.nix`, the `ntfy` secret) and the server (`~/files/school/HTL4/waentw/server-config`) to it.
5. t3code desktop entry: the nixpkgs package ships `t3code.desktop` without `MimeType=x-scheme-handler/t3code;`
   and with `StartupWMClass=t3code` instead of `com.t3tools.T3Code`. Fix it in nixpkgs (PR), then drop the
   `xdg.dataFile."applications/t3code.desktop"` override in `apps.nix`.
