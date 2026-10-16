{ inputs, ... }:
{
  flake.modules.nixos.hardware = {
    imports = [ inputs.nixos-hardware.nixosModules.lenovo-legion-16arh7h-hybrid ];
    boot.initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "usb_storage"
      "sd_mod"
    ];
    boot.kernelModules = [ "kvm-amd" ];
    hardware.enableRedistributableFirmware = true;
    nixpkgs.hostPlatform = "x86_64-linux";

    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.configurationLimit = 10;
    boot.loader.efi.canTouchEfiVariables = true;
    zramSwap.enable = true;
    services.fstrim.enable = true;
    hardware.bluetooth.enable = true;
    services.udev.extraRules = ''
      ACTION=="add|bind", SUBSYSTEM=="platform", DRIVER=="ideapad_acpi", ATTR{conservation_mode}="1"
    '';
  };
}
