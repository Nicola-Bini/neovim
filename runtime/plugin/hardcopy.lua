if vim.g.did_load_hardcopy then
  return
end
vim.g.did_load_hardcopy = 1

vim.api.nvim_create_user_command('Hardcopy', function(cmd)
  vim.cmd('TOhtml')
  local tempBufferNr = vim.api.nvim_get_current_buf()
  local exportFilePath
  if #cmd.fargs == 0 then
    exportFilePath = vim.fn.tempname()
  else
    exportFilePath = cmd.fargs[1]
  end
  vim.cmd('wq' .. ' ' .. vim.fn.fnameescape(exportFilePath))
  vim.cmd('bwipeout!' .. ' ' .. tempBufferNr)
  vim.call('netrw#BrowseX', exportFilePath, 0)
end, {desc = 'Dumps the buffer content into an HTML and opens the browser for viewing or printing', nargs = '?'})

vim.api.nvim_create_user_command('Useless', function(cmd)
    print(#cmd.fargs)
end, {desc = 'Test command', nargs = '?'})


