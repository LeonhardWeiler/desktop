{
  flake.modules.nixos.packages =
    { pkgs, ... }:
    {
      virtualisation.docker.enable = true;
      virtualisation.docker.enableOnBoot = false;
      programs.steam.enable = true;
      programs.kdeconnect.enable = true;
      programs.partition-manager.enable = true;

      programs.chromium = {
        enable = true;
        extensions = [
          "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
          "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock
          "edibdbjcniadpccecjdfdjjppcpchdlm" # I still don't care about cookies
        ];
        extraOpts.RestoreOnStartup = 1;
      };

      environment.systemPackages =
        (with pkgs; [
          (callPackage ../pkgs/helium.nix { })
          (callPackage ../pkgs/eitype.nix { })
          (voxtype.override { vulkanSupport = true; })
          t3code
          bitwarden-desktop
          signal-desktop
          teams-for-linux
          zed-editor
          scribus
          ktailctl
          ktimetracker
          figma-agent
          ghostty
          quickshell
          obs-studio
          audacity
          mixxx
          lsp-plugins
          gcc
          gnumake
          git
          gh
          glab
          typst
          uv
          nodejs
          jq
          btop
          restic
          sops
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
          internetarchive
          wl-clipboard
          wtype
          android-tools
          dnsutils
          acpi
          exfatprogs
          ntfs3g
          dosfstools
          cifs-utils
          qt6Packages.qt6ct
        ])
        ++ (with pkgs.kdePackages; [
          kdenlive
          kcalc
          filelight
          kolourpaint
          isoimagewriter
          keepsecret
          kio-admin
          kdegraphics-thumbnailers
        ]);
    };
}
