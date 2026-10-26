{ inputs, ... }:
{
  flake.modules.nixos.pc = {
    imports = with inputs.nixos-hardware.nixosModules; [
      common-cpu-intel
      common-gpu-nvidia-nonprime
      common-pc-ssd
    ];
    boot.initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    boot.kernelModules = [ "kvm-intel" ];
    hardware.nvidia.open = true;
  };
}
