{
  inputs,
  config,
  lib,
  ...
}:
let
  hosts = [
    "legion"
    "pc"
  ];
  shared = class: builtins.attrValues (removeAttrs config.flake.modules.${class} hosts);
in
{
  flake.nixosConfigurations = lib.genAttrs hosts (
    host:
    inputs.nixpkgs.lib.nixosSystem {
      modules = shared "nixos" ++ [
        (config.flake.modules.nixos.${host} or { })
        {
          networking.hostName = host;
          system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev;
          home-manager.users.${config.user}.imports = shared "homeManager" ++ [
            (config.flake.modules.homeManager.${host} or { })
          ];
        }
      ];
    }
  );

  perSystem.checks = lib.genAttrs hosts (
    host: config.flake.nixosConfigurations.${host}.config.system.build.toplevel
  );
}
