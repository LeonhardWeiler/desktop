local function autocapitalize_on_save()
  if not vim.wo.spell or not vim.bo.modifiable then
    return
  end
  local buf = vim.api.nvim_get_current_buf()
  local view = vim.fn.winsaveview()
  local text = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")

  local edits = {}
  local from = 1
  while from <= #text do
    local sub = string.sub(text, from)
    local bad = vim.fn.spellbadword(sub)
    local word = bad[1]
    if word == "" then
      break
    end
    local mp = vim.fn.matchstrpos(sub, [[\V\<]] .. vim.fn.escape(word, [[\]]) .. [[\>]])
    local ms, me = mp[2], mp[3]
    if ms < 0 then
      local f = string.find(sub, word, 1, true)
      if not f then
        break
      end
      ms, me = f - 1, f - 1 + #word
    end
    if bad[2] == "caps" then
      local first = vim.fn.strcharpart(word, 0, 1)
      local upper = vim.fn.toupper(first)
      if upper ~= first then
        local abs = from - 1
        edits[#edits + 1] = { s = abs + ms, e = abs + me, rep = upper .. string.sub(word, #first + 1) }
      end
    end
    from = from + me
  end

  if #edits > 0 then
    local parts, cur = {}, 0
    for _, ed in ipairs(edits) do
      parts[#parts + 1] = string.sub(text, cur + 1, ed.s)
      parts[#parts + 1] = ed.rep
      cur = ed.e
    end
    parts[#parts + 1] = string.sub(text, cur + 1)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(table.concat(parts), "\n", { plain = true }))
    vim.fn.winrestview(view)
  end
end

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("SpellAutocapitalize", {}),
  pattern = "*",
  callback = function()
    autocapitalize_on_save()
  end,
})
