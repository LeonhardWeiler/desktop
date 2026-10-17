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
    boot.initrd.systemd.enable = true;
  };
}
