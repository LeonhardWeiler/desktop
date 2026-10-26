{ config, ... }:
let
  inherit (config) user nas email;
in
{
  flake.modules.nixos.restore =
    { config, pkgs, ... }:
    let
      marker = "${config.users.users.${user}.home}/.local/state/restored";
      restore = pkgs.writeShellApplication {
        name = "restore";
        runtimeInputs = with pkgs; [
          helium
          tailscale
          bitwarden-cli
          rsync
          openssh
          kdePackages.kdialog
          kdePackages.qttools
        ];
        runtimeEnv = {
          AGE_ITEM = "sops-age-${config.networking.hostName}";
          EMAIL = email;
          MARKER = marker;
          NAS = nas;
          SOPS_AGE_KEY_FILE = config.sops.age.keyFile;
          inherit (config.systemd.services.backup.environment) PATHS RSYNC_RSH REMOTE;
          KEY = config.sops.secrets.backup.path;
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
