{ config, ... }:
{
  flake.modules.nixos.nix = {
    system.stateVersion = "26.11";
    nixpkgs.config.allowUnfree = true;
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [ config.user ];
    };
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    documentation.nixos.enable = false;
    programs.nix-ld.enable = true;
  };
}
