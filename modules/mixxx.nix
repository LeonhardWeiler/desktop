{
  flake.modules.homeManager.mixxx =
    { lib, ... }:
    {
      home.file.".mixxx/Custom.kbd.cfg".source = ./mixxx/Custom.kbd.cfg;
      home.file.".mixxx/soundconfig.xml".source = ./mixxx/soundconfig.xml;
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
