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
      display =
        {
          legion = {
            output = "793d34e8-8a7c-4e4e-a49d-42a6ba557744";
            tiles = [
              0.25
              0.5
              0.25
            ];
          };
          pc = {
            output = "1895da8b-1dc3-4453-ae6d-8e385195f84e";
            tiles = [
              0.5
              0.5
            ];
          };
        }
        .${osConfig.networking.hostName};
      power = brightness: profile: {
        autoSuspend = {
          action = "sleep";
          idleTimeout = 1800;
        };
        whenLaptopLidClosed = "sleep";
        dimDisplay = {
          enable = true;
          idleTimeout = 600;
        };
        displayBrightness = brightness;
        powerProfile = profile;
      };
    in
    {
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
        overrideConfig = true;
        workspace = {
          lookAndFeel = "org.kde.breezedark.desktop";
          inherit wallpaper;
        };
        kscreenlocker = {
          autoLock = true;
          timeout = 20;
          lockOnResume = true;
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
                    "applications:flow.desktop"
                    "applications:thunderbird.desktop"
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
          "services/com.mitchellh.ghostty.desktop"._launch = "Alt+Space";
          "services/helium.desktop"._launch = "Alt+N";
          "services/org.kde.krunner.desktop"._launch = [
            "Alt+F2"
            "Search"
          ];
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
            "Tiling/${desktop}/${display.output}" = {
              padding = 4;
              tiles = builtins.toJSON {
                layoutDirection = "horizontal";
                tiles = map (width: { inherit width; }) display.tiles;
              };
            };
            Plugins.magnifierEnabled = true;
            Effect-magnifier = {
              PointerAxisGestureModifiers = "Alt";
              Width = 400;
              Height = 400;
            };
          };
          dolphinrc = {
            MainWindow.MenuBar = "Disabled";
            "KFileDialog Settings" = {
              "Places Icons Auto-resize" = false;
              "Places Icons Static Size" = 22;
            };
          };
          spectaclerc.GuiConfig.quitAfterSaveCopyExport = true;
          baloofilerc."Basic Settings".Indexing-Enabled = false;
          kwalletrc.Wallet."First Use" = false;
          krunnerrc.Plugins.baloosearchEnabled = false;
          powerdevilrc = lib.genAttrs [ "AC/Display" "Battery/Display" "LowBattery/Display" ] (_: {
            TurnOffDisplayWhenIdle = false;
          });
        };
      };
    };
}
