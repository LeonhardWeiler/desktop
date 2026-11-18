let
  effectcraft =
    { appimageTools, fetchurl }:
    let
      pname = "effectcraft";
      version = "0.24.1";
      src = fetchurl {
        url = "https://github.com/storytold/effectcraft/releases/download/v${version}/effectcraft-${version}-linux-x86_64.AppImage";
        hash = "sha256-n4oWz3QUfJ4qw7ZfpvW+lqPhDq2S3fCNVE9dOZCtZNw=";
      };
      contents = appimageTools.extract { inherit pname version src; };
    in
    appimageTools.wrapType2 {
      inherit pname version src;
      extraInstallCommands = ''
        install -Dm644 ${contents}/ai.storyteller.effectcraft.desktop -t $out/share/applications
        cp -r ${contents}/usr/share/icons $out/share/
      '';
    };
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.effectcraft = pkgs.callPackage effectcraft { };
    };

  flake.modules.nixos.effectcraft =
    { pkgs, ... }:
    {
      environment.systemPackages = [ (pkgs.callPackage effectcraft { }) ];
    };
}
