let
  wallpaper = builtins.path {
    path = ./plasma/monterey-dark.jpg;
    name = "monterey-dark.jpg";
  };
in
{
  flake.modules.nixos.plasma.environment.etc."plasmalogin.conf.d/50-wallpaper.conf".text = ''
    [Greeter][Wallpaper][org.kde.image][General]
    Image=file://${wallpaper}
  '';

  flake.modules.homeManager.plasma =
    {
      config,
      lib,
      osConfig,
      pkgs,
      ...
    }:
    let
      desktop = "d84a00b2-e864-40e5-8264-7ee48d189e5a";
      tiling = {
        padding = 4;
        tiles = builtins.toJSON {
          layoutDirection = "horizontal";
          tiles = map (width: { inherit width; }) [
            0.25
            0.5
            0.25
          ];
        };
      };
      power = brightness: profile: {
        autoSuspend = {
          action = "sleep";
          idleTimeout = 1800;
        };
        whenLaptopLidClosed = "doNothing";
        dimDisplay = {
          enable = true;
          idleTimeout = 600;
        };
        displayBrightness = brightness;
        powerProfile = profile;
      };
    in
    {
      systemd.user.services.refresh-rate = {
        Unit = {
          Description = "Panel refresh rate by power source";
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
                      | "output.\(.name).mode.\($s.width)x\($s.height)@\($hz)"')
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
      xdg.configFile."systemd/user/kunifiedpush-distributor.service".source =
        config.lib.file.mkOutOfStoreSymlink "/dev/null";
      xdg.dataFile =
        lib.genAttrs
          (map (id: "applications/org.kde.${id}.desktop") [
            "kinfocenter"
            "kmenuedit"
            "kwalletmanager"
            "plasma-systemmonitor"
          ])
          (_: {
            text = "[Desktop Entry]\nHidden=true\n";
          });
      programs.plasma = {
        enable = true;
        workspace = {
          lookAndFeel = "org.kde.breezedark.desktop";
          inherit wallpaper;
        };
        kscreenlocker = {
          autoLock = false;
          lockOnResume = false;
          appearance.wallpaper = wallpaper;
        };
        powerdevil = {
          AC = power null "balanced";
          battery = power 40 "powerSaving";
          lowBattery = power 25 "powerSaving";
        };
        input.keyboard.layouts = [ { inherit (osConfig.services.xserver.xkb) layout variant; } ];
        panels = [
          {
            location = "bottom";
            height = 46;
            floating = true;
            widgets = [
              "org.kde.plasma.kickoff"
              "org.kde.plasma.pager"
              {
                iconTasks = {
                  launchers = [
                    "applications:signal.desktop"
                    "applications:com.mitchellh.ghostty.desktop"
                    "applications:t3code.desktop"
                    "applications:helium.desktop"
                  ];
                  appearance.showTooltips = false;
                };
              }
              "org.kde.plasma.marginsseparator"
              "org.kde.plasma.systemtray"
              "org.kde.plasma.digitalclock"
              "org.kde.plasma.showdesktop"
            ];
          }
        ];
        shortcuts = {
          kwin."Window Close" = [
            "Alt+O"
            "Alt+F4"
          ];
          plasmashell = {
            "next activity" = "Meta+A";
            "previous activity" = "Meta+Shift+A";
          };
          "services/com.mitchellh.ghostty.desktop"._launch = "Alt+Space";
          "services/helium.desktop"._launch = "Alt+N";
          "services/org.kde.krunner.desktop"._launch = [
            "Alt+F2"
            "Search"
          ];
          "services/voxtype-toggle.desktop"._launch = "Meta+Space";
        };
        configFile = {
          kdeglobals.General = {
            TerminalApplication = "ghostty";
            TerminalService = "com.mitchellh.ghostty.desktop";
          };
          kdeglobals.KDE = {
            contrast = 4;
            frameContrast = 0.2;
          };
          kwinrc = {
            Desktops = {
              Id_1 = desktop;
              Number = 1;
              Rows = 1;
            };
            "Tiling/${desktop}/5aa7ee16-3ece-45f1-9bac-d2cc82bbe37a" = tiling;
            "Tiling/${desktop}/793d34e8-8a7c-4e4e-a49d-42a6ba557744" = tiling;
            "Tiling/${desktop}/89a182fe-a7ca-460e-89b4-3bb476fe4219" = tiling;
            Xwayland.Scale = 1.25;
          };
          dolphinrc = {
            MainWindow.MenuBar = "Disabled";
            "KFileDialog Settings" = {
              "Places Icons Auto-resize" = false;
              "Places Icons Static Size" = 22;
            };
          };
          baloofilerc."Basic Settings".Indexing-Enabled = false;
          krunnerrc.Plugins.baloosearchEnabled = false;
          kactivitymanagerdrc.activities.a4874b3f-ac87-4f9d-ae97-9e2a3b739115 = "Default";
          powerdevilrc = lib.genAttrs [ "AC/Display" "Battery/Display" "LowBattery/Display" ] (_: {
            TurnOffDisplayWhenIdle = false;
          });
        };
      };
    };
}
