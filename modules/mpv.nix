{
  flake.modules.homeManager.mpv =
    { pkgs, ... }:
    {
      programs.mpv = {
        enable = true;
        scripts = with pkgs.mpvScripts; [
          autoload
          dynamic-crop
          mpv-gallery-view
          thumbfast
        ];
        config = {
          profile = "high-quality";
          hls-bitrate = "max";
          scale = "catmull_rom";
          cscale = "catmull_rom";
          input-ipc-server = "/tmp/mpvsocket";
          window-dragging = false;
          ignore-path-in-watch-later-config = true;
          prefetch-playlist = true;
          force-seekable = true;
          save-position-on-quit = true;
          x11-bypass-compositor = false;
          keep-open = "always";
          screenshot-format = "png";
          screenshot-png-compression = 0;
          screenshot-tag-colorspace = true;
          screenshot-high-bit-depth = true;
          screenshot-directory = "~/Pictures";
          screenshot-template = "~/Pictures/%F-%P-shot-%04n";
          osc = false;
          osd-bar-h = 2;
          osd-bar-w = 75;
          osd-bar-align-y = 0.3;
          osd-border-size = 1;
          osd-color = "#CCFFFFFF";
          osd-border-color = "#99000000";
          osd-duration = 2000;
          osd-font = "sans-serif";
          osd-font-size = 34;
          osd-on-seek = "msg-bar";
          cache = true;
          demuxer-seekable-cache = true;
          demuxer-readahead-secs = 300;
          demuxer-max-bytes = "4000M";
          demuxer-max-back-bytes = "4000M";
        };
        bindings = {
          h = "seek -5";
          l = "seek 5";
          H = "seek -1";
          L = "seek 1";
          j = "add volume -5";
          k = "add volume 5";
          "Ctrl+j" = "cycle sub";
          "Ctrl+J" = "cycle sub down";
          "Ctrl+l" = "ab-loop";
          "Ctrl+L" = ''cycle-values loop-file "inf" "no"'';
          WHEEL_UP = "add volume 5";
          WHEEL_DOWN = "add volume -5";
          WHEEL_LEFT = "seek 5";
          WHEEL_RIGHT = "seek +5";
          "SHIFT+LEFT" = "seek -1";
          "SHIFT+RIGHT" = "seek +1";
          UP = "add volume 5";
          DOWN = "add volume -5";
        };
        scriptOpts.osc = {
          vidscale = false;
          seekbarhandlesize = 0.65;
          timefontsize = 15;
          tooltipfontsize = 16;
          fontweight = "semibold";
          seekbarfgcolor = "FFFFFF";
          seekbarfgheight = 17;
          seekbarbgalpha = 196;
          seekrangealpha = 128;
        };
      };
      xdg.configFile = {
        "mpv/scripts".source = ./mpv/scripts;
        "mpv/fonts".source = "${pkgs.mpvScripts.mpv-osc-modern}/share/fonts/truetype";
      };
    };
}
