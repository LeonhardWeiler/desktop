{
  flake.modules.homeManager.pc =
    { lib, pkgs, ... }:
    {
      systemd.user.services.display = {
        Unit = {
          Description = "Monitor mode and scale";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${lib.getExe pkgs.kdePackages.libkscreen} output.HDMI-A-1.mode.1920x1080@144 output.HDMI-A-1.scale.1";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
}
