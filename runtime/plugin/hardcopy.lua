if vim.g.did_load_hardcopy then
  return
end
vim.g.did_load_hardcopy = 1

vim.api.nvim_create_user_command('Hardcopy', function(cmd)
  vim.cmd('TOhtml')
  local tempBufferNr = vim.api.nvim_get_current_buf()
  local exportTempFilePath = vim.fn.tempname()
  vim.cmd('wq' .. ' ' .. vim.fn.fnameescape(exportTempFilePath))
  vim.cmd('bwipeout!' .. ' ' .. tempBufferNr)
  vim.call('netrw#BrowseX', exportTempFilePath, 0)
end, {desc = 'Dumps the buffer content into an HTML and opens the browser for viewing or printing'})

