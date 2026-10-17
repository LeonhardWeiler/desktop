{ inputs, ... }:
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
      };
      systemd.paths.sops-install-secrets = {
        wantedBy = [ "multi-user.target" ];
        pathConfig.PathExists = config.sops.age.keyFile;
      };
    };
}
