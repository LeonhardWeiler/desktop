{ inputs, ... }:
{
  flake.modules.homeManager.nvim = {
    imports = [ inputs.nixvim.homeModules.nixvim ];

    programs.nixvim =
      { config, pkgs, ... }:
      let
        raw = s: { __raw = s; };
        bind = mode: key: action: { inherit mode key action; };
        desc =
          mode: key: action: d:
          (bind mode key action) // { options.desc = d; };
        telescope = fn: "require('telescope.builtin').${fn}";
      in
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
          autoindent = true;
          smartindent = true;
          clipboard = "unnamedplus";
          hlsearch = false;
          incsearch = true;
          ignorecase = true;
          scrolloff = 10;
          signcolumn = "yes";
          backspace = [
            "indent"
            "eol"
            "start"
          ];
          nrformats = [
            "bin"
            "hex"
            "alpha"
          ];
          updatetime = 50;
          backup = false;
          writebackup = false;
          swapfile = false;
          undofile = true;
        };

        extraFiles."lua/blog.lua".source = ./nvim/blog.lua;
        extraConfigLua = ''
          vim.opt.shortmess:append("c")
          vim.opt.isfname:append("@-@")
          vim.cmd("packadd nvim.tohtml")
          require("blog")
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
            callback = raw ''function() vim.hl.on_yank({ higroup = "IncSearch", timeout = 100 }) end'';
          }
          {
            event = "FileType";
            pattern = [
              "markdown"
              "text"
              "txt"
              "md"
            ];
            callback = raw ''
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

        keymaps = [
          (desc "n" "<leader>e" "<cmd>Oil<cr>" "Oil (file explorer)")
          (bind "v" "J" ":m '>+1<CR>gv=gv")
          (bind "v" "K" ":m '<-2<CR>gv=gv")
          (bind "n" "J" "mzJ`z")
          (bind "n" "<C-d>" "<C-d>zz")
          (bind "n" "<C-u>" "<C-u>zz")
          (bind "n" "<C-f>" "<C-f>zz")
          (bind "n" "<C-b>" "<C-b>zz")
          (bind "n" "n" "nzzzv")
          (bind "n" "N" "Nzzzv")
          (desc "x" "<leader>p" ''"_dp'' "Paste over selection (no clobber)")
          (desc "n" "<leader>S" ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>"
            "Search & replace word under cursor"
          )
          (desc "n" "<leader>sd" (raw "function() vim.diagnostic.setqflist({ open = false }) end")
            "Diagnostics -> quickfix list"
          )
          (bind "n" "<Backspace>" "<Nop>")
          (bind "n" "<F1>" "<Nop>")
          (bind "n" "<Space>" "<Nop>")
          {
            mode = "n";
            key = "<leader>o";
            action = raw ''
              function()
                local filepath = vim.fn.expand("%:p")
                if filepath == "" then
                  vim.notify("📛 No file path for the current buffer", vim.log.levels.WARN)
                  return
                end
                vim.fn.jobstart({ "xdg-open", filepath }, { detach = true })
              end
            '';
            options = {
              desc = "Open link in browser";
              silent = true;
            };
          }
          (desc "n" "<leader>a" (raw "function() require('harpoon'):list():add() end") "Harpoon: pin file")
          (desc "n" "<leader>h"
            (raw "function() local h = require('harpoon') h.ui:toggle_quick_menu(h:list()) end")
            "Harpoon: menu"
          )
          (desc "n" "<leader>f" (raw "function() ${telescope "find_files"}({ hidden = true }) end")
            "Find files (inkl. hidden, ohne gitignore)"
          )
          (desc "n" "<leader>sg" (raw (telescope "live_grep")) "Live grep")
          (desc "n" "<leader>sh" (raw (telescope "help_tags")) "Help tags")
          (desc "n" "<leader>sc" (raw (telescope "colorscheme")) "Colorscheme")
          (desc "n" "<leader>sq" (raw (telescope "quickfix")) "Quickfix list")
          (desc "n" "<leader>sl" (raw (telescope "spell_suggest")) "Spell suggestions")
          (desc "n" "<leader>sk" (raw (telescope "keymaps")) "Keymaps")
          (desc "n" "<leader>st" (raw (telescope "filetypes")) "Filetypes")
        ]
        ++ builtins.genList (
          i:
          let
            n = toString (i + 1);
          in
          desc "n" "<leader>${n}" (raw "function() require('harpoon'):list():select(${n}) end")
            "Harpoon: file ${n}"
        ) 4;

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
              callback = raw ''
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
                is_hidden_file = raw ''function(name, _) return name:match("^%.") ~= nil end'';
                is_always_hidden = raw "function(_, _) return false end";
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
                  action = raw "vim.diagnostic.open_float";
                }
                {
                  key = "[d";
                  action = raw "function() vim.diagnostic.jump({ count = -1 }) end";
                }
                {
                  key = "]d";
                  action = raw "function() vim.diagnostic.jump({ count = 1 }) end";
                }
              ];
        };
      };
  };
}
