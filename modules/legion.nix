{ inputs, config, ... }:
{
  flake.nixosConfigurations.legion = inputs.nixpkgs.lib.nixosSystem {
    modules = builtins.attrValues config.flake.modules.nixos ++ [
      {
        networking.hostName = "legion";
        system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev;
      }
    ];
  };

  perSystem.checks.legion = config.flake.nixosConfigurations.legion.config.system.build.toplevel;
}
