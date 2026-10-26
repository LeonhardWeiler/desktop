{
  flake.modules.homeManager.shell =
    { config, pkgs, ... }:
    let
      repo = "${config.home.homeDirectory}/files/repos/desktop";
      nix-update = "${pkgs.nix-update}/bin/nix-update --flake --commit";
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

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        silent = true;
        config.whitelist.prefix = [ "${config.home.homeDirectory}/files" ];
      };

      programs.bash = {
        enable = true;
        historyFile = "$HOME/.local/state/bash/history";
        historySize = null;
        historyFileSize = null;
        shellOptions = [ "histappend" ];
        shellAliases = {
          open = "xdg-open";
          dot = "cd ${repo}";
          rebuild = "git -C ${repo} pull --rebase --autostash && nh os switch";
          update = "(cd ${repo} && git pull --rebase --autostash && nix flake update --commit-lock-file && ${nix-update} helium && ${nix-update} eitype) && nh os switch && git -C ${repo} push";
          backup = "sudo systemctl start --no-block backup && journalctl -fu backup";
          notes = "cd $HOME/files/repos/notes/";
          arst = "sudo shutdown now";
          todo = ''nvim "$(git rev-parse --show-toplevel)/AGENT/TODO.md"'';
          camera = "ffplay -f v4l2 /dev/video0 -vf hflip -x 1280 -y 720";
          screenshot = "spectacle --region";
        };
        initExtra = ''
          PS1='$([ -e /sys/class/power_supply/BAT0 ] && echo "$(</sys/class/power_supply/BAT0/capacity)% ")\w \$ '
        '';
      };
    };
}
