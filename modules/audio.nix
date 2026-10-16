{
  flake.modules.nixos.audio =
    { pkgs, ... }:
    let
      lv2 = [ pkgs.lsp-plugins ];
    in
    {
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
        jack.enable = true;
        extraLv2Packages = lv2;
        extraConfig.pipewire."99-custom"."context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.allowed-rates" = [ 48000 ];
          "default.clock.quantum" = 1024;
          "default.clock.min-quantum" = 256;
          "default.clock.max-quantum" = 2048;
          "resample.quality" = 10;
        };
        extraConfig.pipewire."10-eq"."context.modules" = [
          {
            name = "libpipewire-module-filter-chain";
            args = {
              "node.description" = "10 Band EQ";
              "media.name" = "10 Band EQ";
              "filter.graph".nodes = [
                {
                  type = "lv2";
                  name = "eq";
                  plugin = "http://lsp-plug.in/plugins/lv2/graph_equalizer_x16_stereo";
                  control = {
                    xe_3 = 1;
                    xe_4 = 1;
                    xe_5 = 0;
                    xe_6 = 1;
                    xe_7 = 1;
                    xe_8 = 1;
                    xe_9 = 1;
                    xe_10 = 0;
                    xe_11 = 1;
                    xe_12 = 1;
                    xe_13 = 0;
                    xe_14 = 1;
                    xe_15 = 1;
                    g_3 = 5.6234;
                    g_4 = 3.9811;
                    g_6 = 1.7783;
                    g_7 = 1.1220;
                    g_8 = 1.1220;
                    g_9 = 1.4125;
                    g_11 = 1.0;
                    g_12 = 1.0;
                    g_14 = 1.1220;
                    g_15 = 1.1220;
                  };
                }
              ];
              "capture.props" = {
                "node.name" = "10-band-eq";
                "media.class" = "Audio/Sink";
              };
              "playback.props"."node.name" = "10-band-eq-output";
            };
          }
        ];
        extraConfig.jack."20-dj-jack"."jack.properties" = {
          "node.latency" = "256/48000";
          "node.rate" = "1/48000";
          "node.lock-quantum" = true;
        };
      };
      security.rtkit.enable = true;
      security.pam.loginLimits = [
        {
          domain = "@audio";
          item = "rtprio";
          type = "-";
          value = "95";
        }
        {
          domain = "@audio";
          item = "memlock";
          type = "-";
          value = "unlimited";
        }
      ];
      environment.systemPackages = lv2;
      environment.sessionVariables.LV2_PATH = "/run/current-system/sw/lib/lv2";
    };
}
