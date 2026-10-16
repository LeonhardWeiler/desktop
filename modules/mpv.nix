{
  flake.modules.homeManager.mpv =
    { pkgs, ... }:
    {
      programs.mpv = {
        enable = true;
        scripts = with pkgs.mpvScripts; [
          autoload
          dynamic-crop
          modernz
          mpv-gallery-view
          thumbfast
        ];
        config = {
          profile = "high-quality";
          hls-bitrate = "max";
          scale = "catmull_rom";
          cscale = "catmull_rom";
          window-dragging = false;
          ignore-path-in-watch-later-config = true;
          prefetch-playlist = true;
          force-seekable = true;
          save-position-on-quit = true;
          watch-later-options-remove = "sub-pos";
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
          demuxer-max-bytes = "500M";
          demuxer-max-back-bytes = "250M";
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
        scriptOpts.modernz = {
          vidscale = "no";
          show_title = false;
          window_controls = false;
          time_font_size = 15;
          tooltip_font_size = 16;
          seek_handle_size = 0.65;
          seekbarfg_color = "#FFFFFF";
          seek_handle_color = "#FFFFFF";
          seek_handle_border_color = "#FFFFFF";
          hover_effect_color = "#FFFFFF";
          nibble_color = "#FFFFFF";
          seekrangealpha = 128;
        };
      };
      xdg.configFile."mpv/fonts".source = "${pkgs.mpvScripts.modernz}/share/fonts/truetype";
    };
}
