{
  flake.modules.nixos.packages =
    { pkgs, ... }:
    {
      programs.steam.enable = true;
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
          ktailctl
          ktimetracker
          figma-agent
          ghostty
          quickshell
          obs-studio
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
          kcalc
          filelight
          kolourpaint
          keepsecret
          kio-admin
          kdegraphics-thumbnailers
        ]);
    };
}
