{ config, lib, ... }:
{
  options.user = lib.mkOption { type = lib.types.str; };
  options.nas = lib.mkOption { type = lib.types.str; };
  options.email = lib.mkOption { type = lib.types.str; };
  options.name = lib.mkOption { type = lib.types.str; };

  config.user = "leo";
  config.nas = "nas.taild9564d.ts.net";
  config.email = "leonhard-weiler@hotmail.com";
  config.name = "Leonhard Weiler";

  config.flake.modules.nixos.base = {
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
      description = config.name;
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "dialout"
      ];
    };
  };
}
