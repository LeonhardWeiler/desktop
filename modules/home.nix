{ inputs, config, ... }:
{
  flake.modules.nixos.home = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
      users.${config.user}.imports = builtins.attrValues config.flake.modules.homeManager;
    };
  };

  flake.modules.homeManager.home.home.stateVersion = "26.11";
}
