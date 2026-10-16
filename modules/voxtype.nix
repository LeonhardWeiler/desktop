{
  flake.modules.homeManager.voxtype =
    {
      lib,
      pkgs,
      osConfig,
      ...
    }:
    let
      toml = pkgs.formats.toml { };
    in
    {
      xdg.configFile."voxtype/config.toml".source = toml.generate "config.toml" {
        state_file = "auto";
        hotkey.enabled = false;
        audio = {
          device = "default";
          sample_rate = 16000;
          max_duration_secs = 300;
          feedback = {
            enabled = true;
            theme = "subtle";
            volume = 0.5;
          };
        };
        whisper = {
          model = "large-v3-turbo";
          language = "de";
          on_demand_loading = false;
        };
        output = {
          mode = "type";
          driver_order = [
            "wtype"
            "eitype"
            "clipboard"
          ];
          eitype_xkb_layout = osConfig.services.xserver.xkb.layout;
          eitype_xkb_variant = osConfig.services.xserver.xkb.variant;
          type_delay_ms = 2;
        };
        osd = {
          enabled = true;
          frontend = "quickshell";
          style = "handy";
          position = "bottom-center";
          width_px = 180;
          top_margin = 0.9;
        };
      };

      xdg.configFile."voxtype/osd/handy/voxtype-osd.toml".source = toml.generate "voxtype-osd.toml" {
        name = "handy";
        version = "0.1.0";
        description = "Small dark pill with white level bars, after Handy on macOS.";
        palette = "package";
        layout = "minimal";
        colors = {
          accent = "#FFFFFF";
          foreground = "#FFFFFF";
          background = "rgba(0, 0, 0, 0.85)";
          surface = "rgba(0, 0, 0, 0.85)";
          muted = "rgba(255, 255, 255, 0.35)";
          success = "#FFFFFF";
          warning = "#FFFFFF";
          error = "#F2594D";
          recording = "#FFFFFF";
          streaming = "#FFFFFF";
          transcribing = "rgba(255, 255, 255, 0.6)";
          idle = "rgba(255, 255, 255, 0.6)";
        };
        frame = {
          background = "background";
          border = "none";
          glow = false;
          halo = false;
        };
        visual.layers = [
          {
            type = "bars";
            source = "peak";
            color = "accent";
            order = 10;
            x = 0.05;
            y = 0.15;
            width = 0.9;
            height = 0.7;
            gain = 0.3;
            radius = 3;
          }
        ];
      };

      xdg.configFile."autostart/voxtype.desktop".text = lib.generators.toINI { } {
        "Desktop Entry" = {
          Type = "Application";
          Name = "voxtype";
          Comment = "Dictation daemon (voice to text)";
          Exec = "voxtype daemon";
          Terminal = false;
          X-GNOME-Autostart-enabled = true;
          OnlyShowIn = "KDE;";
        };
      };

      xdg.dataFile."applications/voxtype-toggle.desktop".text = lib.generators.toINI { } {
        "Desktop Entry" = {
          Type = "Application";
          Name = "Dictation (voxtype)";
          Comment = "Start/stop a voxtype recording";
          Exec = "voxtype record toggle";
          Icon = "audio-input-microphone";
          Terminal = false;
          NoDisplay = true;
          X-KDE-Shortcuts = "Meta+Space";
        };
      };
    };
}
