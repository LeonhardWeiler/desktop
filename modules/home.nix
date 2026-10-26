{ inputs, ... }:
{
  flake.modules.nixos.home = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
    };
  };

  flake.modules.homeManager.home.home.stateVersion = "26.11";
}
