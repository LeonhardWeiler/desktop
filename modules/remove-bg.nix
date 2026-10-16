{
  flake.modules.homeManager.remove-bg =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.writers.writePython3Bin "remove-bg" {
          libraries = [ pkgs.python3Packages.rembg ];
          doCheck = false;
        } (builtins.readFile ./remove-bg.py))
      ];
    };
}
