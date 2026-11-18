{ inputs, ... }:
{
  flake.modules.nixos.legion =
    { pkgs, ... }:
    let
      gpu = "/sys/bus/pci/devices/0000:01:00.0/power/control";
    in
    {
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
        ACTION=="add|bind", SUBSYSTEM=="pci", KERNEL=="0000:01:00.0", RUN+="${pkgs.coreutils}/bin/chgrp wheel ${gpu}", RUN+="${pkgs.coreutils}/bin/chmod g+w ${gpu}"
        ACTION=="change", SUBSYSTEM=="drm", KERNEL=="card0", ENV{CONNECTOR}=="?*", RUN+="${pkgs.runtimeShell} -c 'grep -q ^disconnected /sys%p/card0-HDMI-A-1/status && echo auto > ${gpu}'"
      '';
      environment.systemPackages = [
        (pkgs.writeShellScriptBin "hdmi" ''
          case ''${1:-on} in
            on) echo on > ${gpu} ;;
            off) echo auto > ${gpu} ;;
            *) echo "usage: hdmi [on|off]" >&2; exit 1 ;;
          esac
        '')
      ];
    };
}
