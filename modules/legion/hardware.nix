{ inputs, ... }:
{
  flake.modules.nixos.legion = {
    imports = [ inputs.nixos-hardware.nixosModules.lenovo-legion-16arh7h-hybrid ];
    boot.initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "usb_storage"
      "sd_mod"
    ];
    boot.kernelModules = [ "kvm-amd" ];
    services.udev.extraRules = ''
      ACTION=="add|bind", SUBSYSTEM=="platform", DRIVER=="ideapad_acpi", ATTR{conservation_mode}="1"
    '';
  };
}
