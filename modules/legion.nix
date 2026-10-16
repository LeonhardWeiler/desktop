{ inputs, config, ... }:
{
  flake.nixosConfigurations.legion = inputs.nixpkgs.lib.nixosSystem {
    modules = builtins.attrValues config.flake.modules.nixos ++ [
      {
        system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev;
      }
    ];
  };
}
