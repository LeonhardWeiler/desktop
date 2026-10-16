{ inputs, config, ... }:
let
  inherit (config) user;
in
{
  flake.modules.nixos.secrets =
    { config, pkgs, ... }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];
      environment.systemPackages = [ pkgs.sops ];
      environment.variables.SOPS_AGE_KEY_FILE = config.sops.age.keyFile;
      security.sudo.extraConfig = "Defaults env_keep += SOPS_AGE_KEY_FILE";
      sops = {
        defaultSopsFile = ./secrets.yaml;
        age.keyFile = "/var/lib/sops-nix/key.txt";
        useSystemdActivation = true;
        secrets = {
          restic.owner = user;
          ntfy = { };
          "nas/leonhard-files" = { };
          "nas/shared-files" = { };
          "nas/old-drive" = { };
        };
      };
      systemd.paths.sops-install-secrets = {
        wantedBy = [ "multi-user.target" ];
        pathConfig.PathExists = config.sops.age.keyFile;
      };
    };
}
