{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      nixos-hardware,
      disko,
      ...
    }:
    {
      nixosConfigurations.arch = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.lenovo-legion-16arh7h-hybrid
          disko.nixosModules.disko
          ./disko.nix
          ./hardware.nix
          ./configuration.nix
        ];
      };
    };
}
