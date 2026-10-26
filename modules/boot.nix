{
  flake.modules.nixos.boot = {
    hardware.enableRedistributableFirmware = true;
    nixpkgs.hostPlatform = "x86_64-linux";
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.configurationLimit = 10;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.timeout = 1;
    zramSwap.enable = true;
    hardware.bluetooth.enable = true;
  };
}
