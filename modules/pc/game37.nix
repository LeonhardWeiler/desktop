{ inputs, ... }:
{
  flake.modules.nixos.pc =
    { pkgs, ... }:
    {
      environment.systemPackages = [ inputs.game37.packages.${pkgs.stdenv.hostPlatform.system}.default ];
    };
}
