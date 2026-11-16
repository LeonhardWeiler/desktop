let
  flow =
    { appimageTools, fetchurl }:
    let
      pname = "flow";
      version = "0.1.0-beta4";
      src = fetchurl {
        url = "https://github.com/Flow-Tube/Flow-Desktop/releases/download/v${version}/Flow_${version}_linux_amd64.AppImage";
        hash = "sha256-6pcj0t/kLkzAlBbfrA4reOfWQjZmvKOmUo/KeUXuamw=";
      };
      contents = appimageTools.extract { inherit pname version src; };
    in
    appimageTools.wrapType2 {
      inherit pname version src;
      extraPkgs = pkgs: [ pkgs.libgpg-error ];
      profile = "unset QT_PLUGIN_PATH";
      extraInstallCommands = ''
        install -Dm644 "${contents}/Flow Beta.desktop" $out/share/applications/flow.desktop
        cp -r ${contents}/usr/share/icons $out/share/
      '';
    };
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.flow = pkgs.callPackage flow { };
    };

  flake.modules.nixos.flow =
    { pkgs, ... }:
    {
      environment.systemPackages = [ (pkgs.callPackage flow { }) ];
    };
}
