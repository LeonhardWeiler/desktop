{
  flake.modules.homeManager.shell =
    { config, ... }:
    let
      repo = "${config.home.homeDirectory}/files/repos/desktop";
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
      home.sessionPath = [
        "$HOME/.local/bin"
        "$GOPATH/bin"
      ];
      systemd.user.sessionVariables = vars;

      programs.bash = {
        enable = true;
        historyFile = "$HOME/.local/state/bash/history";
        historySize = null;
        historyFileSize = null;
        shellOptions = [ "histappend" ];
        shellAliases = {
          open = "xdg-open";
          dot = "cd ${repo}";
          rebuild = "sudo nixos-rebuild switch --flake ${repo}";
          update = "nix flake update --flake ${repo} --commit-lock-file && rebuild && git -C ${repo} push";
          notes = "cd $HOME/files/repos/notes/";
          arst = "sudo shutdown now";
          todo = ''nvim "$(git rev-parse --show-toplevel)/AGENT/TODO.md"'';
          camera = "ffplay -f v4l2 /dev/video0 -vf hflip -x 1280 -y 720";
          screenshot = "spectacle --region";
        };
        initExtra = ''
          PS1='$(</sys/class/power_supply/BAT0/capacity)% \w \$ '
        '';
      };
    };
}
