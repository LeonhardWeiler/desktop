{ config, lib, ... }:
{
  options.user = lib.mkOption { type = lib.types.str; };

  config.user = "leo";

  config.flake.modules.nixos.base = {
    networking.hostName = "legion";
    time.timeZone = "Europe/Vienna";
    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "mod-dh-iso-uk";
    services.xserver.xkb = {
      layout = "gb";
      variant = "colemak_dh";
    };

    networking.networkmanager.enable = true;
    networking.modemmanager.enable = false;
    services.tailscale.enable = true;
    services.tailscale.extraSetFlags = [ "--operator=${config.user}" ];

    users.users.${config.user} = {
      isNormalUser = true;
      description = "Leonhard Weiler";
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "input"
        "dialout"
      ];
    };
  };
}
