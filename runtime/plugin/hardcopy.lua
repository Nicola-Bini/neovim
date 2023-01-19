if vim.g.did_load_hardcopy then
  return
end
vim.g.did_load_hardcopy = 1

--- This function check if the system on which Neovim is running offers to Neovim a command to open
--- files, this is needed by the extension to decide if convert the buffer to HTML and send to a
--- browser or use a fallback printing/exporting system
--- @return boolean
local function test_netrw_BrowseX()
  if vim.g.netrw_browsex_viewer ~= nil then
    -- If the user manually configured netrw_browsex_viewer the function trusts his configuration
    -- and avoids any further check

    -- Check if specific handler for HTML exists?

    return true
  else
    if vim.fn.has('win32') ~= 0 then
      -- Almost any version of Windows is shipped with a browser allowing the viewing of HTML files,
      -- the only exception is Windows Server Core (TODO: handle and test the case on virtual
      -- machine) and Windows Nano Server which is made to run just on containers and may not
      -- support Neovim at all (TODO: verify this assumption)
      return true
    elseif vim.fn.has('unix') ~= 0 then
      if vim.loop.os_uname().sysname == "Darwin" then
        -- macOS always has a full GUI and a browser... even on servers
        return true
      else
        -- Check if one of the default programs used by Netrw to open files exists
        return vim.fn.system('which xdg-open') ~= "" or
          vim.fn.system('which gnome-open') ~= "" or
          vim.fn.system('which kfmclient') ~= ""
      end
    else
      return false
    end
  end
end

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

local function unix_fallback_printing_system()

  -- Todo: add check to see if the system supports fallback printing

  local function parse_raw_printer_list(lpstat_output)
    local printer_names = {}
    for match in string.gmatch(lpstat_output, " [^ /#]+: ") do
      local printer_name = string.sub(match, 2, -3)
      table.insert(printer_names, printer_name)
    end

    return printer_names
  end

  local raw_printer_list = vim.fn.system('lpstat -v')
  local parsed_printer_list = parse_raw_printer_list(raw_printer_list)
  
  error("Not yet implemented")

end

--- Stub for printing/exporting systems which are going to be used when Netrw cannot open a valid
--- HTML viewer on the system
local function print_or_export_with_the_fallback_systems()
  if vim.fn.has('win32') ~= 0 then
    error("Fallback printing not implemented for Windows")
  elseif vim.fn.has('unix') ~= 0 then
    error("Fallback printing not implemented for unix")
  else
    error("Fallback printing not implemented for the current system")
  end
end

vim.api.nvim_create_user_command('Hardcopy', function(cmd)

  local force_fallback_printing = cmd.bang

  -- Todo if test_netrw_BrowseX needs to be called each time Hardcopy is invoked or running it at
  -- the extension loading is enough
  if test_netrw_BrowseX() and not force_fallback_printing then
    export_to_html_and_open_output(cmd.fargs[1])
  else
    print_or_export_with_the_fallback_systems()
  end
end, {desc = 'Dumps the buffer content into an HTML and opens the browser for viewing or printing', nargs = '?'})

