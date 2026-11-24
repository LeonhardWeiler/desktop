{
  flake.modules.nixos.pc =
    { pkgs, ... }:
    {
      programs.steam.enable = true;
      programs.steam.extraCompatPackages = [ pkgs.proton-ge-bin ];
      programs.gamemode.enable = true;
      boot.kernelModules = [ "ntsync" ];
    };
}
