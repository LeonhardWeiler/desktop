{ inputs, ... }:
{
  flake.modules.nixos.secrets =
    { config, ... }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];
      sops = {
        defaultSopsFile = ./secrets.yaml;
        age.keyFile = "/home/leo/.config/sops/age/keys.txt";
        useSystemdActivation = true;
        secrets = {
          restic.owner = "leo";
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
