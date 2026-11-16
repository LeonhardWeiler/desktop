{
  flake.modules.nixos.boot = {
    hardware.enableRedistributableFirmware = true;
    nixpkgs.hostPlatform = "x86_64-linux";
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.configurationLimit = 10;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.timeout = 1;
    zramSwap.enable = true;
    zramSwap.memoryPercent = 100;
    boot.kernel.sysctl."vm.swappiness" = 180;
    boot.kernel.sysctl."vm.page-cluster" = 0;
    hardware.bluetooth.enable = true;
  };
}
