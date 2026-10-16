{
  flake.modules.homeManager.mpv =
    let
      gallery = {
        gallery_position = "{ (ww - gw) / 2, (wh - gh) / 2 }";
        gallery_size = "{ 9 * ww / 10, 9 * wh / 10 }";
        min_spacing = "{ 15, 15 }";
        thumbnail_size = "(ww * wh <= 1366 * 768) and {192, 108} or {288, 162}";
        max_thumbnails = 64;
        pause_on_start = true;
        resume_on_stop = "only-if-did-pause";
        text_size = 28;
        background_color = "333333";
        background_opacity = "33";
        normal_border_color = "BBBBBB";
        normal_border_size = 1;
        selected_border_color = "E5E4E5";
        selected_border_size = 6;
        placeholder_color = "222222";
        command_on_open = "";
        command_on_close = "";
        mouse_support = true;
        UP = "UP";
        DOWN = "DOWN";
        LEFT = "LEFT";
        RIGHT = "RIGHT";
        PAGE_UP = "PGUP";
        PAGE_DOWN = "PGDWN";
        FIRST = "HOME";
        LAST = "END";
        RANDOM = "r";
        ACCEPT = "ENTER";
        CANCEL = "ESC";
      };
    in
    {
      programs.mpv = {
        enable = true;
        config = {
          profile = "gpu-hq";
          hls-bitrate = "max";
          scale = "catmull_rom";
          cscale = "catmull_rom";
          input-ipc-server = "/tmp/mpvsocket";
          window-dragging = false;
          ignore-path-in-watch-later-config = true;
          prefetch-playlist = true;
          force-seekable = true;
          msg-color = true;
          correct-pts = true;
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
          LEFT = "seek -5";
          RIGHT = "seek 5";
          "SHIFT+LEFT" = "seek -1";
          "SHIFT+RIGHT" = "seek +1";
          UP = "add volume 5";
          DOWN = "add volume -5";
        };
        scriptOpts = {
          osc = {
            showtitle = false;
            windowcontrols = false;
            vidscale = false;
            seekbarhandlesize = 0.65;
            timefontsize = 15;
            tooltipfontsize = 16;
            fontweight = "semibold";
            seekbarfgcolor = "FFFFFF";
            seekbarfgheight = 17;
            seekbarbgcolor = "FFFFFF";
            seekbarbgalpha = 196;
            seekbarbgheight = 2;
            seekrangealpha = 128;
          };
          contact_sheet = gallery // {
            gallery_position = "{ (ww - gw) / 2, (wh - gh) / 2}";
            mkdir_thumbs = true;
            time_distance = "2%";
            chapter_mode = false;
            chapter_mode_time_offset = 2;
            chapter_mode_fallback_to_time_steps = true;
            seek_on_toggle_off = false;
            close_on_seek = true;
            show_text = "selection";
            show_millisecond_precision = true;
            highlight_previous = true;
            previous_border_color = "EBC5A7";
            previous_border_size = 4;
          };
          playlist_view = gallery // {
            take_thumbnail_at = "20%";
            load_file_on_toggle_off = false;
            close_on_load_file = true;
            start_on_mpv_startup = false;
            start_on_file_end = true;
            follow_playlist_position = false;
            remember_time_position = true;
            show_text = true;
            show_title = true;
            strip_directory = true;
            strip_extension = true;
            highlight_active = true;
            active_border_color = "EBC5A7";
            active_border_size = 4;
            flagged_border_color = "96B58D";
            flagged_border_size = 4;
            flagged_file_path = "./mpv_gallery_flagged";
            REMOVE = "DEL";
            FLAG = "SPACE";
          };
        };
      };
      xdg.configFile = {
        "mpv/scripts".source = ./mpv/scripts;
        "mpv/script-modules".source = ./mpv/script-modules;
        "mpv/fonts".source = ./mpv/fonts;
      };
    };
}
