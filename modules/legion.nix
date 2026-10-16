{ inputs, config, ... }:
{
  flake.nixosConfigurations.legion = inputs.nixpkgs.lib.nixosSystem {
    modules = builtins.attrValues config.flake.modules.nixos;
  };
}
