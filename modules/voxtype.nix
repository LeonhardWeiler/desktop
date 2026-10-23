let
  eitype =
    {
      rustPlatform,
      fetchFromGitHub,
      pkg-config,
      libxkbcommon,
    }:
    rustPlatform.buildRustPackage rec {
      pname = "eitype";
      version = "0.2.2";
      src = fetchFromGitHub {
        owner = "Adam-D-Lewis";
        repo = "eitype";
        tag = version;
        hash = "sha256-s5g6METDi8/jPEwZursorYWN8X96VlyVPtd8dCCVIlw=";
      };
      cargoHash = "sha256-k0JU3Y83aPHgQpyiG6DXxBzdYSMOmH42kPCxXWtNtkQ=";
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [ libxkbcommon ];
      doCheck = false;
    };
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.eitype = pkgs.callPackage eitype { };
    };

  flake.modules.homeManager.voxtype =
    {
      lib,
      pkgs,
      osConfig,
      ...
    }:
    let
      toml = pkgs.formats.toml { };
      model = "large-v3-turbo";
    in
    {
      home.packages = [
        (pkgs.callPackage eitype { })
        pkgs.quickshell
      ];
      services.voxtype = {
        enable = true;
        package = pkgs.voxtype.override { vulkanSupport = true; };
        loadModels = [ model ];
        environment.PATH = "/etc/profiles/per-user/%u/bin:/run/current-system/sw/bin";
        settings = {
          hotkey.enabled = false;
          audio = {
            max_duration_secs = 300;
            feedback = {
              enabled = true;
              theme = "subtle";
              volume = 0.5;
            };
          };
          whisper = {
            inherit model;
            language = "de";
          };
          output = {
            driver_order = [
              "eitype"
              "clipboard"
            ];
            eitype_xkb_layout = osConfig.services.xserver.xkb.layout;
            eitype_xkb_variant = osConfig.services.xserver.xkb.variant;
            type_delay_ms = 2;
          };
          osd = {
            frontend = "quickshell";
            style = "handy";
            width_px = 180;
            top_margin = 0.9;
          };
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

      programs.plasma.shortcuts."services/voxtype-toggle.desktop"._launch = "Meta+Space";
      xdg.dataFile."applications/voxtype-toggle.desktop".text = lib.generators.toINI { } {
        "Desktop Entry" = {
          Type = "Application";
          Name = "Dictation (voxtype)";
          Comment = "Start/stop a voxtype recording";
          Exec = "voxtype record toggle";
          Icon = "audio-input-microphone";
          Terminal = false;
          NoDisplay = true;
        };
      };
    };
}
