{
  flake.modules.homeManager.cli = {
    programs.btop = {
      enable = true;
      settings = {
        proc_sorting = "memory";
        net_sync = false;
        shown_gpus = "nvidia amd intel";
        save_config_on_exit = false;
      };
    };
  };
}
