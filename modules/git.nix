{ config, ... }:
let
  inherit (config) email name;
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
            ${email} ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINq94P7mB2E1HvwZMJnU5aKfVqa79pq5FPPcUltYNnks
            ${email} ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOCrqU5a7z7td7FNMwiHHADHG3SzLoWHwKnYOrN5czzB
            ${email} ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINgP0BFI+h8vNSGDvyaL0CI3ULXr1ZEPZywRK/r79+5s
          '';
        };
        ignores = [
          "**/.claude/settings.local.json"
          "*.bak"
          ".direnv/"
        ];
      };
    };
}
