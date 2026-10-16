{
  flake.modules.homeManager.cli =
    { lib, ... }:
    {
      programs.btop = {
        enable = true;
        settings = {
          proc_sorting = "memory";
          net_sync = false;
          shown_gpus = "nvidia amd intel";
          save_config_on_exit = false;
        };
      };
      xdg.configFile."pip/pip.conf".text = lib.generators.toINI { } {
        global.break-system-packages = true;
      };
    };
}
