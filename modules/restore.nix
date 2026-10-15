{
  flake.modules.nixos.restore =
    { pkgs, ... }:
    let
      restore = pkgs.writeShellApplication {
        name = "restore";
        runtimeInputs = with pkgs; [
          (callPackage ../pkgs/helium.nix { })
          tailscale
          bitwarden-cli
          restic
          jq
          kdePackages.kdialog
          kdePackages.qttools
        ];
        text = builtins.readFile ./restore.sh;
      };
    in
    {
      environment.systemPackages = [ restore ];
      environment.etc."xdg/autostart/restore.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=Restore
        Exec=${restore}/bin/restore
      '';
    };
}
