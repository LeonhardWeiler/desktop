{
  flake.modules.nixos.dotfiles = {
    systemd.user.tmpfiles.users.leo.rules = [
      "L+ %h/.config/nvim - - - - /home/leo/files/repos/desktop/home/.config/nvim"
    ];
  };
}
