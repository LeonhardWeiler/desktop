{
  flake.modules.homeManager.nvim.programs.nixvim =
    { lib, ... }:
    let
      raw = lib.nixvim.mkRaw;
      bind = mode: key: action: { inherit mode key action; };
      desc =
        mode: key: action: d:
        (bind mode key action) // { options.desc = d; };
      telescope = fn: "require('telescope.builtin').${fn}";
    in
    {
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
    };
}
