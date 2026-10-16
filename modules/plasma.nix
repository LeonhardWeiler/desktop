{
  flake.modules.homeManager.plasma =
    { lib, osConfig, ... }:
    let
      wallpaper = ./plasma/monterey-dark.jpg;
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
        turnOffDisplay.idleTimeout = "never";
        displayBrightness = brightness;
        powerProfile = profile;
      };
    in
    {
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
          kactivitymanagerdrc.activities.a4874b3f-ac87-4f9d-ae97-9e2a3b739115 = "Default";
          powerdevilrc = lib.genAttrs [ "AC/Display" "Battery/Display" "LowBattery/Display" ] (_: {
            TurnOffDisplayWhenIdle = false;
          });
        };
      };
    };
}
