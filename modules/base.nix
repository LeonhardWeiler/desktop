{
  flake.modules.nixos.base = {
    networking.hostName = "arch";
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
    services.tailscale.extraSetFlags = [ "--operator=leo" ];

    users.users.leo = {
      isNormalUser = true;
      description = "Leonhard Weiler";
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
        "audio"
        "input"
        "dialout"
      ];
    };
  };
}
