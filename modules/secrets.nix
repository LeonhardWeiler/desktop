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
      sops = {
        defaultSopsFile = ./secrets.yaml;
        age.keyFile = "${config.users.users.${user}.home}/.config/sops/age/keys.txt";
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
