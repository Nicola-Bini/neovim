if vim.g.did_load_hardcopy then
  return
end
vim.g.did_load_hardcopy = 1

local function export_to_html_and_open_output(output_file_path)
  vim.cmd('TOhtml')
  local tempBufferNr = vim.api.nvim_get_current_buf()
  local exportFilePath
  if output_file_path then
    exportFilePath = output_file_path
  else
    exportFilePath = vim.fn.tempname()
  end
  vim.cmd('wq' .. ' ' .. vim.fn.fnameescape(exportFilePath))
  vim.cmd('bwipeout!' .. ' ' .. tempBufferNr)
  vim.call('netrw#BrowseX', exportFilePath, 0)
end

vim.api.nvim_create_user_command('Hardcopy', function(cmd)
  export_to_html_and_open_output(cmd.fargs[1])
end, {desc = 'Dumps the buffer content into an HTML and opens the browser for viewing or printing', nargs = '?'})

