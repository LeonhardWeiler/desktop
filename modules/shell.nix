{
  flake.modules.homeManager.shell =
    let
      vars = {
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
        EDITOR = "nvim";
        BROWSER = "helium";
        GOPATH = "$HOME/.local/share/go";
        npm_config_cache = "$HOME/.cache/npm";
      };
    in
    {
      home.sessionVariables = vars;
      systemd.user.sessionVariables = vars;

      programs.bash = {
        enable = true;
        historyFile = "$HOME/.local/state/bash/history";
        historySize = null;
        historyFileSize = null;
        shellOptions = [ "histappend" ];
        shellAliases = {
          open = "xdg-open";
          dot = "cd $HOME/files/repos/desktop";
          rebuild = "sudo nixos-rebuild switch --flake $HOME/files/repos/desktop#arch";
          notes = "cd $HOME/files/repos/notes/";
          arst = "sudo shutdown now";
          todo = "nvim ./AGENT/TODO.md";
          claude = "claude --dangerously-skip-permissions";
          camera = "ffplay -f v4l2 /dev/video0 -vf hflip -x 1280 -y 720";
          screenshot = "spectacle --region";
        };
        profileExtra = ''[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"'';
        initExtra = ''
          BAT_CAPACITY=
          for _bat in /sys/class/power_supply/*; do
            [ -r "$_bat/type" ] && [ "$(<"$_bat/type")" = Battery ] && [ -r "$_bat/capacity" ] || continue
            BAT_CAPACITY="$_bat/capacity"
            break
          done
          unset _bat

          update_battery() {
            if [ -n "$BAT_CAPACITY" ] && [ -r "$BAT_CAPACITY" ]; then
              battery="$(<"$BAT_CAPACITY")% "
            else
              battery=""
            fi
          }

          PROMPT_COMMAND=update_battery
          PS1='$battery\w \$ '

          export PATH="$HOME/.local/bin:$GOPATH/bin:$PATH"
        '';
      };
    };
}
