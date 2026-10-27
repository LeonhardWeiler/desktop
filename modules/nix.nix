{ inputs, config, ... }:
{
  flake.modules.nixos.nix = {
    imports = [ inputs.nix-index-database.nixosModules.nix-index ];
    system.stateVersion = "26.11";
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    nix.channel.enable = false;
    nix.settings.commit-lock-file-summary = "flake: update inputs";
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
    nix.settings.extra-substituters = [ "https://nixos-raspberrypi.cachix.org" ];
    nix.settings.extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
    nix.optimise.automatic = true;
    documentation.nixos.enable = false;
    programs.nix-ld.enable = true;
    programs.nh = {
      enable = true;
      flake = "/home/${config.user}/files/repos/desktop";
      clean.enable = true;
      clean.extraArgs = "--keep-since 30d --keep 5";
    };
    programs.nix-index-database.comma.enable = true;
    services.dbus.implementation = "broker";
  };
}
