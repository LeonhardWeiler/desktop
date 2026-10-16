{
  flake.modules.homeManager.nvim.programs.nixvim =
    { lib, ... }:
    {
      lsp = {
        servers = {
          lua_ls = {
            enable = true;
            config.settings.Lua = {
              completion.callSnippet = "Replace";
              diagnostics.globals = [ "vim" ];
              workspace.checkThirdParty = false;
            };
          };
          tinymist = {
            enable = true;
            config.settings.projectResolution = "lockDatabase";
          };
          emmet_ls = {
            enable = true;
            config.filetypes = [
              "html"
              "css"
              "scss"
              "javascriptreact"
              "typescriptreact"
            ];
          };
          html.enable = true;
          cssls.enable = true;
          vtsls.enable = true;
          gopls.enable = true;
          marksman.enable = true;
        };
        keymaps =
          map
            (
              k:
              k
              // {
                mode = "n";
                options.silent = true;
              }
            )
            [
              {
                key = "gd";
                lspBufAction = "definition";
              }
              {
                key = "gr";
                lspBufAction = "references";
              }
              {
                key = "K";
                lspBufAction = "hover";
              }
              {
                key = "<leader>r";
                lspBufAction = "rename";
              }
              {
                key = "<leader>c";
                lspBufAction = "code_action";
              }
              {
                key = "<leader>d";
                action = lib.nixvim.mkRaw "vim.diagnostic.open_float";
              }
              {
                key = "[d";
                action = lib.nixvim.mkRaw "function() vim.diagnostic.jump({ count = -1 }) end";
              }
              {
                key = "]d";
                action = lib.nixvim.mkRaw "function() vim.diagnostic.jump({ count = 1 }) end";
              }
            ];
      };
    };
}
