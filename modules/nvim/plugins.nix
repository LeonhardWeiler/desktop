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
            keymaps = {
              "g?" = {
                __unkeyed-1 = "actions.show_help";
                mode = "n";
              };
              "<CR>" = "actions.select";
              "<C-s>" = {
                __unkeyed-1 = "actions.select";
                opts.vertical = true;
              };
              "<C-h>" = {
                __unkeyed-1 = "actions.select";
                opts.horizontal = true;
              };
              "<C-t>" = {
                __unkeyed-1 = "actions.select";
                opts.tab = true;
              };
              "<C-p>" = "actions.preview";
              "<C-c>" = {
                __unkeyed-1 = "actions.close";
                mode = "n";
              };
              "<C-l>" = "actions.refresh";
              "-" = {
                __unkeyed-1 = "actions.parent";
                mode = "n";
              };
              "_" = {
                __unkeyed-1 = "actions.open_cwd";
                mode = "n";
              };
              "`" = {
                __unkeyed-1 = "actions.cd";
                mode = "n";
              };
              "~" = {
                __unkeyed-1 = "actions.cd";
                opts.scope = "tab";
                mode = "n";
              };
              "gs" = {
                __unkeyed-1 = "actions.change_sort";
                mode = "n";
              };
              "gx" = "actions.open_external";
              "g." = {
                __unkeyed-1 = "actions.toggle_hidden";
                mode = "n";
              };
              "g\\" = {
                __unkeyed-1 = "actions.toggle_trash";
                mode = "n";
              };
            };
            view_options = {
              show_hidden = true;
              is_hidden_file = lib.nixvim.mkRaw ''function(name, _) return name:match("^%.") ~= nil end'';
              is_always_hidden = lib.nixvim.mkRaw "function(_, _) return false end";
            };
          };
        };

        lualine = {
          enable = true;
          settings = {
            options = {
              theme = "auto";
              icons_enabled = true;
              section_separators = "";
              component_separators = "";
              always_divide_middle = true;
              globalstatus = false;
              refresh = {
                statusline = 1000;
                tabline = 1000;
                winbar = 1000;
              };
            };
            sections = {
              lualine_a = [ "mode" ];
              lualine_b = [
                "branch"
                "diff"
                "diagnostics"
              ];
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
              lualine_z = [ "location" ];
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
