{
  flake.modules.nixos.packages =
    { pkgs, ... }:
    {
      programs.steam.enable = true;
      programs.partition-manager.enable = true;

      environment.systemPackages =
        (with pkgs; [
          bitwarden-desktop
          signal-desktop
          teams-for-linux
          zed-editor
          ktailctl
          ktimetracker
          figma-agent
          ghostty
          obs-studio
          gcc
          gnumake
          typst
          uv
          nodejs
          jq
          rsync
          wget
          zip
          unzip
          file
          ffmpeg
          exiftool
          mat2
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
