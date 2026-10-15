{ inputs, config, ... }:
{
  flake.nixosConfigurations.arch = inputs.nixpkgs.lib.nixosSystem {
    modules = builtins.attrValues config.flake.modules.nixos;
  };
}
