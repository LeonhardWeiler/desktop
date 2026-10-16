{ config, ... }:
let
  inherit (config) repo nas;
in
{
  flake.modules.nixos.restore =
    { config, pkgs, ... }:
    let
      restore = pkgs.writeShellApplication {
        name = "restore";
        runtimeInputs = with pkgs; [
          helium
          tailscale
          bitwarden-cli
          restic
          jq
          kdePackages.kdialog
          kdePackages.qttools
        ];
        runtimeEnv = {
          REPO = repo;
          NAS = nas;
          SOPS_AGE_KEY_FILE = config.sops.age.keyFile;
          RESTIC_REPOSITORY = config.services.restic.backups.nas.repository;
          RESTIC_PASSWORD_FILE = config.sops.secrets.restic.path;
        };
        text = builtins.readFile ./restore.sh;
      };
    in
    {
      environment.systemPackages = [ restore ];
      environment.etc."xdg/autostart/restore.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=Restore
        Exec=${restore}/bin/restore
      '';
    };
}
