{
  flake.modules.nixos.audio =
    { pkgs, ... }:
    {
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
        jack.enable = true;
        extraLv2Packages = [ pkgs.lsp-plugins ];
      };
      security.rtkit.enable = true;
      security.pam.loginLimits = [
        {
          domain = "@audio";
          item = "rtprio";
          type = "-";
          value = "95";
        }
        {
          domain = "@audio";
          item = "memlock";
          type = "-";
          value = "unlimited";
        }
      ];
      environment.sessionVariables.LV2_PATH = "/run/current-system/sw/lib/lv2";
    };
}
