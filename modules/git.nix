{ config, ... }:
let
  inherit (config) email name;
  schoolEmail = "leonhard.weiler@edu.htl-villach.at";
in
{
  flake.modules.homeManager.git =
    { config, pkgs, ... }:
    {
      home.packages = [
        pkgs.gh
        pkgs.glab
      ];
      programs.git = {
        enable = true;
        settings = {
          user.email = email;
          user.name = name;
          core.editor = "nvim";
          init.defaultBranch = "main";
        };
        signing = {
          format = "ssh";
          key = "${config.home.homeDirectory}/.ssh/id_ed25519";
          signByDefault = true;
          allowedSigners = ''
            ${email},${schoolEmail} ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINq94P7mB2E1HvwZMJnU5aKfVqa79pq5FPPcUltYNnks
            ${email},${schoolEmail} ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOCrqU5a7z7td7FNMwiHHADHG3SzLoWHwKnYOrN5czzB
            ${email},${schoolEmail} ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINgP0BFI+h8vNSGDvyaL0CI3ULXr1ZEPZywRK/r79+5s
          '';
        };
        includes = map (url: {
          condition = "hasconfig:remote.*.url:${url}";
          contents.user.email = schoolEmail;
        }) [ "git@gitlab.com:*/**" "https://gitlab.com/**" ];
        ignores = [
          "**/.claude/settings.local.json"
          "*.bak"
          ".direnv/"
        ];
      };
    };
}
