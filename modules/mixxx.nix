{
  flake.modules.homeManager.mixxx =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.mixxx ];
      home.file.".mixxx/Custom.kbd.cfg".source = ./mixxx/Custom.kbd.cfg;
      home.file.".mixxx/soundconfig.xml".source = ./mixxx/soundconfig.xml;
    };
}
