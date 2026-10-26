{
  flake.modules.homeManager.legion =
    { lib, pkgs, ... }:
    {
      programs.plasma.configFile.kwinrc.Xwayland.Scale = 1.25;
      systemd.user.services.refresh-rate = {
        Unit = {
          Description = "Panel scale and refresh rate by power source";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = lib.getExe (
            pkgs.writeShellApplication {
              name = "refresh-rate";
              runtimeInputs = [
                pkgs.jq
                pkgs.kdePackages.libkscreen
                pkgs.systemd
              ];
              text = ''
                last=
                while :; do
                  hz=60
                  [ "$(< /sys/class/power_supply/ADP0/online)" = 1 ] && hz=165
                  if [ "$hz" != "$last" ]; then
                    # shellcheck disable=SC2046
                    kscreen-doctor $(kscreen-doctor -j | jq -r --arg hz "$hz" '
                      .outputs[] | select(.name | startswith("eDP"))
                      | .currentModeId as $id | (.modes[] | select(.id == $id).size) as $s
                      | "output.\(.name).mode.\($s.width)x\($s.height)@\($hz)", "output.\(.name).scale.1.25"')
                    last=$hz
                  fi
                  read -r _ || exit
                done < <(udevadm monitor --udev --subsystem-match=power_supply)
              '';
            }
          );
          Restart = "always";
          RestartSec = 10;
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
}
