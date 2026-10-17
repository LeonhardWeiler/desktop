# TODO

1. LUKS and Secure Boot: encrypt the btrfs partition in `disko.nix` (LUKS, unlocked via TPM2 with
   `systemd-cryptenroll`), sign the boot chain with lanzaboote. Needs a reinstall with `install.sh` and `restore`.
   TPM2 unlock needs `security.tpm2.enable = true` (systemd initrd is already on); `bootctl` currently
   reports `TPM2 Support: no`.
2. Manually maintained packages: `helium` (AppImage overlay in `helium.nix`) and `eitype` (in `voxtype.nix`)
   are not in nixpkgs and `update` does not bump them. Helium had 8 releases in 4 weeks. Package them in nixpkgs,
   then use `pkgs.helium` and `pkgs.eitype`.
   - A Helium package must keep `--ro-bind-try /etc/chromium /etc/chromium` in bwrap, otherwise the
     `programs.chromium` policies from `helium.nix` do not reach the browser.
3. t3code desktop entry: the nixpkgs package ships `t3code.desktop` without `MimeType=x-scheme-handler/t3code;`
   and with `StartupWMClass=t3code` instead of `com.t3tools.T3Code`. Fix it in nixpkgs (PR), then drop the
   `xdg.dataFile."applications/t3code.desktop"` override in `apps.nix`.
4. Old age key copies: until 2026-10-17 the age key lived in `~/.config/sops/age/keys.txt`, so it is in the btrbk
   snapshots of `/home` (expire after 8 weeks), readable by leo, and in the old restic repository, deleted on
   2026-10-17 but still in the NAS btrbk snapshots (12 months) and on the external backup disk.
   With it the old revisions of `secrets.yaml` in git decrypt to the current values. Rotate the
   secrets themselves (backup ssh key, NAS SMB credentials, ntfy topic), then the age key (`age-keygen`, new
   recipient in `.sops.yaml`, `sudo sops updatekeys modules/secrets.yaml`, new `sops-age` in Bitwarden).
5. `restore.sh` is only checked with shellcheck, never run end to end (Bitwarden login, age key install via sudo,
   rsync as root via the backup key, marker). Run it on the reinstall of item 1 and fix what breaks.
