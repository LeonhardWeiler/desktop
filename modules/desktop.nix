{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      services.desktopManager.plasma6.enable = true;
      services.displayManager.plasma-login-manager.enable = true;
      environment.plasma6.excludePackages = with pkgs.kdePackages; [
        elisa
        kate
        khelpcenter
        konsole
        krdp
        plasma-browser-integration
        plasma-keyboard
        plasma-workspace-wallpapers
        qrca
        qtvirtualkeyboard
      ];
      programs.kde-pim.enable = false;
      services.orca.enable = false;
      services.speechd.enable = false;
      services.geoclue2.enable = false;
      programs.nano.enable = false;
      environment.defaultPackages = [ ];

      fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        nerd-fonts.jetbrains-mono
        (runCommand "cv-fonts"
          {
            nativeBuildInputs = [ python3Packages.fonttools ];
            inter = fetchzip {
              url = "https://github.com/rsms/inter/releases/download/v3.19/Inter-3.19.zip";
              stripRoot = false;
              hash = "sha256-6kUQUTFtxiJEU6sYC6HzMwm1H4wvaKIoxoY3F6GJJa8=";
            };
            sora =
              map
                (
                  { w, hash }:
                  fetchurl {
                    url = "https://raw.githubusercontent.com/sora-xor/sora-font/7f9a9c5d0ccd1c099cfac420aa27133df1c5fdc4/fonts/ttf/Sora-${w}.ttf";
                    inherit hash;
                  }
                )
                [
                  {
                    w = "Regular";
                    hash = "sha256-UX6UXe2+641wDMrnfRiabvKgH23MlbpdAy75ow9/Dek=";
                  }
                  {
                    w = "SemiBold";
                    hash = "sha256-sCYh1ACdqaGOuKXL4nfwhOucPwZboIpud3aegYY77PI=";
                  }
                  {
                    w = "Bold";
                    hash = "sha256-LuYpU2aDRrCv+DmUp4ZPde5rhEP5mJToj0dVlFQpEVU=";
                  }
                  {
                    w = "ExtraBold";
                    hash = "sha256-KyUiBk/0fngNQE/cfoO//8qCz98Dd9m+fv9DWYAmuSY=";
                  }
                ];
            caslon = fetchurl {
              url = "https://raw.githubusercontent.com/google/fonts/47d54ca1ebb14fd864695f1d39dc734f39017c33/ofl/librecaslontext/LibreCaslonText%5Bwght%5D.ttf";
              name = "LibreCaslonText.ttf";
              hash = "sha256-wRgJ2/1URYhik9ibMr/CWEB1yA53dQzxwoQRPja4s/Q=";
            };
          }
          ''
            d=$out/share/fonts/truetype
            mkdir -p $d
            cp "$inter"/"Inter Hinted for Windows"/Desktop/*.ttf $d
            for f in $sora; do cp $f $d/''${f#*-}; done
            fonttools varLib.instancer $caslon wght=400 --update-name-table -o $d/LibreCaslonText-Regular.ttf
          ''
        )
      ];
      fonts.fontconfig.localConf = "<fontconfig><dir>~/files/jl/grafiken/fonts</dir></fontconfig>";
    };
}
