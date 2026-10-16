vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("SpellAutocapitalize", {}),
  callback = function(args)
    if not vim.wo.spell or not vim.bo[args.buf].modifiable then
      return
    end
    for row, line in ipairs(vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)) do
      local bad = vim.spell.check(line)
      for i = #bad, 1, -1 do
        local word, kind, col = unpack(bad[i])
        local first = vim.fn.strcharpart(word, 0, 1)
        local upper = vim.fn.toupper(first)
        if kind == "caps" and upper ~= first then
          vim.api.nvim_buf_set_text(args.buf, row - 1, col - 1, row - 1, col - 1 + #first, { upper })
        end
      end
    end
  end,
})
