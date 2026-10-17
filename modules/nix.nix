{
  flake.modules.nixos.nix = {
    system.stateVersion = "26.11";
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    nix.channel.enable = false;
    nix.settings.commit-lock-file-summary = "flake: update inputs";
    nix.optimise.automatic = true;
    documentation.nixos.enable = false;
    programs.nix-ld.enable = true;
  };
}
