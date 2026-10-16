{
  flake.modules.nixos.helium =
    { pkgs, ... }:
    {
      nixpkgs.overlays = [
        (final: _: {
          helium =
            let
              pname = "helium";
              version = "0.19.3.1";
              src = final.fetchurl {
                url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
                hash = "sha256-Rg5tKlyG0DkhYkItGyF6NmMb2DD40h5WUYyWAgl5eQY=";
              };
              contents = final.appimageTools.extract { inherit pname version src; };
            in
            final.appimageTools.wrapType2 {
              inherit pname version src;
              extraInstallCommands = ''
                install -Dm644 ${contents}/helium.desktop $out/share/applications/helium.desktop
                cp -r ${contents}/usr/share/icons $out/share/
              '';
            };
        })
      ];
      environment.systemPackages = [ pkgs.helium ];
      programs.chromium = {
        enable = true;
        extensions = [
          "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
          "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock
          "edibdbjcniadpccecjdfdjjppcpchdlm" # I still don't care about cookies
        ];
        extraOpts.RestoreOnStartup = 1;
      };
    };
}
