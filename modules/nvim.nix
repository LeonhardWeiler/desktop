{ inputs, ... }:
{
  flake.modules.homeManager.nvim = {
    imports = [ inputs.nixvim.homeModules.nixvim ];

    programs.nixvim =
      { lib, pkgs, ... }:
      {
        enable = true;
        nixpkgs.source = inputs.nixpkgs;
        extraPackages = [ pkgs.go ];

        globals = {
          mapleader = " ";
          maplocalleader = "\\";
        };

        opts = {
          number = true;
          relativenumber = true;
          mouse = "";
          wrap = false;
          termguicolors = true;
          cursorline = true;
          fillchars.eob = " ";
          tabstop = 2;
          softtabstop = 2;
          shiftwidth = 2;
          expandtab = true;
          smartindent = true;
          clipboard = "unnamedplus";
          hlsearch = false;
          ignorecase = true;
          scrolloff = 10;
          signcolumn = "yes";
          nrformats = [
            "bin"
            "hex"
            "alpha"
          ];
          updatetime = 50;
          writebackup = false;
          swapfile = false;
          undofile = true;
          exrc = true;
        };

        extraConfigLua = ''
          vim.opt.shortmess:append("c")
          vim.opt.isfname:append("@-@")
          vim.cmd("packadd nvim.tohtml")
          ${builtins.readFile ./nvim/autocapitalize.lua}
        '';

        colorschemes.kanagawa = {
          enable = true;
          settings = {
            compile = true;
            functionStyle.italic = true;
            background.dark = "dragon";
            colors.theme.all.ui.bg_gutter = "none";
          };
        };

        diagnostic.settings = {
          virtual_lines = true;
          underline = true;
          severity_sort = true;
          float = {
            border = "rounded";
            source = true;
          };
        };

        autoCmd = [
          {
            event = "TextYankPost";
            group = "HighlightYank";
            pattern = "*";
            callback = lib.nixvim.mkRaw ''function() vim.hl.on_yank({ higroup = "IncSearch", timeout = 100 }) end'';
          }
          {
            event = "FileType";
            pattern = [
              "markdown"
              "text"
            ];
            callback = lib.nixvim.mkRaw ''
              function(args)
                vim.opt_local.wrap = true
                vim.opt_local.linebreak = true
                vim.opt_local.spell = true
                vim.opt_local.spelllang = "en,de"
                vim.keymap.set("n", "j", "gj", { noremap = true, buffer = args.buf })
                vim.keymap.set("n", "k", "gk", { noremap = true, buffer = args.buf })
              end
            '';
          }
        ];
        autoGroups.HighlightYank = { };
      };
  };
}
