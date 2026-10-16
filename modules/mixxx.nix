{
  flake.modules.homeManager.mixxx =
    { lib, pkgs, ... }:
    let
      skin = pkgs.runCommand "mixxx-skin" { nativeBuildInputs = [ pkgs.ffmpeg-headless ]; } ''
        MIXXX_SKIN_DIR=${pkgs.mixxx}/share/mixxx/skins MIXXX_SETTINGS_DIR=$out XDG_CONFIG_HOME=$out \
          sh ${./mixxx/skin}/build-skin
      '';
    in
    {
      home.file.".mixxx/Custom.kbd.cfg".source = ./mixxx/Custom.kbd.cfg;
      home.file.".mixxx/soundconfig.xml".source = ./mixxx/soundconfig.xml;
      home.file.".mixxx/skins".source = "${skin}/skins";
      home.file.".mixxx/prefs.qss".source = "${skin}/prefs.qss";
      xdg.configFile.qt6ct.source = "${skin}/qt6ct";
      home.activation.mixxxSkin = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        [ -e ~/.mixxx/mixxx.cfg ] || printf "[Config]\nResizableSkin LateNight-Leo\nScheme Leo\n" >~/.mixxx/mixxx.cfg
      '';
      xdg.dataFile."applications/org.mixxx.Mixxx.desktop".text = lib.generators.toINI { } {
        "Desktop Entry" = {
          Version = "1.0";
          Name = "Mixxx";
          GenericName = "Digital DJ interface";
          Comment = "A digital DJ interface";
          Exec = ''sh -c 'QT_QPA_PLATFORMTHEME=qt6ct exec mixxx -stylesheet "$HOME/.mixxx/prefs.qss" "$@"' mixxx %U'';
          Keywords = "dj;music;alsa;jack:realtime;standalone;";
          Terminal = false;
          Icon = "mixxx";
          Type = "Application";
          StartupNotify = true;
          StartupWMClass = "org.mixxx.mixxx";
          Categories = "Qt;AudioVideo;Audio;Midi;Mixer;Player;Recorder;Sequencer;";
        };
      };
    };
}
