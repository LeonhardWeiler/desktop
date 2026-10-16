{
  flake.modules.homeManager.nvim.programs.nixvim =
    { config, lib, ... }:
    {
      plugins = {
        blink-cmp = {
          enable = true;
          settings = {
            keymap.preset = "default";
            snippets.preset = "luasnip";
            appearance.nerd_font_variant = "mono";
            completion = {
              documentation = {
                auto_show = true;
                auto_show_delay_ms = 200;
              };
              ghost_text.enabled = true;
            };
            signature.enabled = true;
            sources = {
              default = [
                "lsp"
                "path"
                "snippets"
                "buffer"
                "lazydev"
              ];
              providers.lazydev = {
                name = "LazyDev";
                module = "lazydev.integrations.blink";
                score_offset = 100;
              };
            };
            fuzzy.implementation = "prefer_rust_with_warning";
          };
        };
        luasnip = {
          enable = true;
          fromVscode = [ { } ];
        };
        friendly-snippets.enable = true;
        lazydev = {
          enable = true;
          settings.library = [
            {
              path = "\${3rd}/luv/library";
              words = [ "vim%.uv" ];
            }
          ];
        };

        conform-nvim = {
          enable = true;
          autoInstall.enable = true;
          settings = {
            formatters_by_ft = {
              lua = [ "stylua" ];
              javascript = [ "biome" ];
              typescript = [ "biome" ];
              javascriptreact = [ "biome" ];
              typescriptreact = [ "biome" ];
              json = [ "biome" ];
              html = [ "prettier" ];
              css = [ "biome" ];
              markdown = [ "prettier" ];
              go = [
                "goimports"
                "gofumpt"
              ];
              typst = [ "typstyle" ];
            };
            format_on_save = {
              timeout_ms = 1000;
              lsp_format = "fallback";
            };
          };
        };

        lint = {
          enable = true;
          autoInstall.enable = true;
          lintersByFt = {
            javascript = [ "biomejs" ];
            typescript = [ "biomejs" ];
            javascriptreact = [ "biomejs" ];
            typescriptreact = [ "biomejs" ];
            go = [ "golangcilint" ];
          };
          autoCmd = {
            event = [
              "BufReadPost"
              "BufWritePost"
              "InsertLeave"
            ];
            callback = lib.nixvim.mkRaw ''
              function()
                if vim.bo.buftype == "" then
                  require("lint").try_lint()
                end
              end
            '';
          };
        };

        lspconfig.enable = true;
        harpoon.enable = true;
        telescope.enable = true;
        comment.enable = true;
        gitsigns.enable = true;
        typst-preview.enable = true;
        mini-pairs.enable = true;
        mini-icons = {
          enable = true;
          mockDevIcons = true;
          settings.directory.AGENT = {
            glyph = "󰚩";
            hl = "MiniIconsPurple";
          };
        };

        oil = {
          enable = true;
          settings = {
            columns = [
              "icon"
              "size"
            ];
            delete_to_trash = true;
            prompt_save_on_select_new_entry = true;
            skip_confirm_for_simple_edits = true;
            watch_for_changes = true;
            keymaps."~" = {
              __unkeyed-1 = "actions.cd";
              opts.scope = "tab";
              mode = "n";
            };
            view_options.show_hidden = true;
          };
        };

        lualine = {
          enable = true;
          settings = {
            options = {
              section_separators = "";
              component_separators = "";
            };
            sections = {
              lualine_c = [
                {
                  __unkeyed-1 = "filename";
                  file_status = true;
                  newfile_status = true;
                  path = 1;
                  symbols = {
                    modified = "";
                    readonly = "";
                    unnamed = "";
                    newfile = "";
                  };
                }
              ];
              lualine_x = [
                "encoding"
                "fileformat"
              ];
              lualine_y = [ "filetype" ];
            };
          };
        };

        treesitter = {
          enable = true;
          highlight.enable = true;
          indent.enable = true;
          grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
            bash
            css
            diff
            git_config
            gitcommit
            go
            gomod
            gosum
            html
            javascript
            json
            lua
            luadoc
            markdown
            markdown_inline
            query
            tsx
            typescript
            typst
            vim
            vimdoc
          ];
        };
      };
    };
}
