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
      ];
    };
}
