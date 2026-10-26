{
  flake.modules.nixos.pc =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.prismlauncher
        pkgs.lunar-client
      ];
    };
}
