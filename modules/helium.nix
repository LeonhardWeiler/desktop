let
  helium =
    { appimageTools, fetchurl }:
    let
      pname = "helium";
      version = "0.20.1.1";
      src = fetchurl {
        url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
        hash = "sha256-1LeJsl0KmuEsdmceRE6Khe3Pgo4EGcZ40YxB+xrDAw4=";
      };
      contents = appimageTools.extract { inherit pname version src; };
    in
    appimageTools.wrapType2 {
      inherit pname version src;
      extraBwrapArgs = [ "--ro-bind-try /etc/chromium /etc/chromium" ];
      extraInstallCommands = ''
        install -Dm644 ${contents}/helium.desktop $out/share/applications/helium.desktop
        cp -r ${contents}/usr/share/icons $out/share/
      '';
    };
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.helium = pkgs.callPackage helium { };
    };

  flake.modules.nixos.helium =
    { pkgs, ... }:
    {
      nixpkgs.overlays = [ (final: _: { helium = final.callPackage helium { }; }) ];
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
