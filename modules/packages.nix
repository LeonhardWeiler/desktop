{
  flake.modules.nixos.packages =
    { pkgs, ... }:
    {
      programs.partition-manager.enable = true;

      systemd.packages = [
        (pkgs.writeTextDir "lib/systemd/user/app-com.mitchellh.ghostty.service.d/10-type.conf" "[Service]\nType=dbus\n")
      ];

      environment.systemPackages =
        (with pkgs; [
          bitwarden-desktop
          signal-desktop
          teams-for-linux
          slack
          zed-editor
          ktailctl
          ktimetracker
          figma-agent
          ghostty
          typst
          jq
          rsync
          wget
          zip
          unzip
          file
          ffmpeg
          qpdf
          ps_mem
          wl-clipboard
          android-tools
          dnsutils
          acpi
          exfatprogs
          ntfs3g
          dosfstools
        ])
        ++ (with pkgs.kdePackages; [
          kcalc
          filelight
          kolourpaint
          keepsecret
          kio-admin
          kdegraphics-thumbnailers
        ]);
    };
}
