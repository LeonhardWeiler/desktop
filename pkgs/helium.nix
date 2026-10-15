{ appimageTools, fetchurl }:
let
  pname = "helium";
  version = "0.19.3.1";
  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = "sha256-Rg5tKlyG0DkhYkItGyF6NmMb2DD40h5WUYyWAgl5eQY=";
  };
  contents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;
  extraInstallCommands = ''
    install -Dm644 ${contents}/helium.desktop $out/share/applications/helium.desktop
    cp -r ${contents}/usr/share/icons $out/share/
  '';
}
