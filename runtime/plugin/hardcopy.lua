if vim.g.did_load_hardcopy then
  return
end
vim.g.did_load_hardcopy = 1

--- Exports the content of the current buffer to an HTML file and tries
--- to open it in a browser for printing or exporting to other file formats
--- @param output_file_path? string output file path, if nil a temporary file will be created
local function export_to_html_and_open_output(output_file_path)
  vim.cmd('TOhtml')
  local temp_buffer_nr = vim.api.nvim_get_current_buf()
  local export_file_path
  if output_file_path then
    export_file_path = output_file_path
  else
    export_file_path = vim.fn.tempname()
  end
  vim.cmd('wq' .. ' ' .. vim.fn.fnameescape(export_file_path))
  vim.cmd('bwipeout!' .. ' ' .. temp_buffer_nr)
  vim.call('netrw#BrowseX', export_file_path, 0)
end

vim.api.nvim_create_user_command('Hardcopy', function(cmd)
  export_to_html_and_open_output(cmd.fargs[1])
end, {desc = 'Dumps the buffer content into an HTML and opens the browser for viewing or printing', nargs = '?'})

