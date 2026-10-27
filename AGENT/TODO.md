# TODO

1. LUKS and Secure Boot: encrypt the btrfs partition in `disko.nix` (LUKS, unlocked via TPM2 with
   `systemd-cryptenroll`), sign the boot chain with lanzaboote. Needs a reinstall with `install.sh` and `restore`.
   TPM2 unlock needs `security.tpm2.enable = true` (systemd initrd is already on); `bootctl` currently
   reports `TPM2 Support: no`.
2. `helium` (`helium.nix`) and `eitype` (`voxtype.nix`) are flake packages bumped by `nix-update` in `update`.
   Package them in nixpkgs, then use `pkgs.helium` and `pkgs.eitype` and drop the `nix-update` calls.
   - A Helium package must keep `--ro-bind-try /etc/chromium /etc/chromium` in bwrap, otherwise the
     `programs.chromium` policies from `helium.nix` do not reach the browser.
3. t3code desktop entry: the nixpkgs package ships `t3code.desktop` without `MimeType=x-scheme-handler/t3code;`
   and with `StartupWMClass=t3code` instead of `com.t3tools.T3Code`. Fix it in nixpkgs (PR), then drop the
   `xdg.dataFile."applications/t3code.desktop"` override in `apps.nix`.
4. Old age key copies: until 2026-10-17 the age key lived in `~/.config/sops/age/keys.txt`, so it is in the btrbk
   snapshots of `/home` (expire after 8 weeks), readable by leo, and in the old restic repository, deleted on
   2026-10-17 but still in the NAS btrbk snapshots (12 months) and on the external backup disk.
   With it the old revisions of `secrets.yaml` in git decrypt to the current values. Rotate the
   secrets themselves (backup ssh key, NAS SMB credentials; the ntfy topic is only reachable on the tailnet and
   stays), then the age key (`age-keygen`, new recipient in `.sops.yaml`, `sudo sops updatekeys modules/secrets.yaml`, new `sops-age-legion` and `sops-age-pc` in Bitwarden).
5. `restore.sh` is only checked with shellcheck, never run end to end (Bitwarden login, age key install via sudo,
   rsync as root via the backup key, marker). Run it on the reinstall of item 1 and fix what breaks.
6. Sync `~/files/school` between pc and legion with Syncthing, the NAS (`syncthing-leonhard` in
   `~/files/repos/nas/syncthing.nix`) as always-on hub at `/data/leonhard-files/school`. Backups stay per host.
   - Merge once by hand: compare both copies (`rsync -avun --itemize-changes`, or the legion copy in
     `backup/legion` on the NAS), resolve conflicts, put the result on the NAS.
   - New module `syncthing.nix`: `services.syncthing` as user service, NAS device (port 22000 + uid - 1000 = 22001
     over Tailscale) and folder `school` declared, global/local announce and relays off like on the NAS.
   - NAS repo: add the pc and legion device IDs to `site.nix` under `syncthing.leonhard`.
   - `.stignore`: `node_modules`, `.direnv`, `result`.
   - `HTL4/waentw/.git` is synced too; do not work on it on both hosts at the same time.
7. Flow: from 2026-11-10, check whether Flow Desktop `v0.1.0-beta3` is released and `update` bumped `flow.nix` to it.
   If it is flagged as pre-release on GitHub, `nix-update` skips it; bump `version` and `hash` by hand.
   Then compare CPU with beta2: the WebKit main thread was ~90 % of a core during video on beta2, ~50 % on
   nightly 733 (rest is WebKitGTK video painting, not Flow code; 0 % when paused).
