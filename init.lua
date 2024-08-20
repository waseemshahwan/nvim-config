require("config.lazy")

-- Set indent size to 2 spaces
vim.opt.expandtab = true
vim.opt.shiftwidth = 2

-- Use the first parameter to determine working directory
local args = vim.fn.argv()
if #args > 0 then
  local path = args[1]
  if vim.fn.isdirectory(path) == 1 then
    vim.cmd('cd ' .. path)
  else
    vim.cmd('cd ' .. vim.fn.fnamemodify(path, ':p:h'))
  end
end

-- Enable line numbers
vim.opt.number = true

-- Toggle Neotree with <A-Tab>
vim.api.nvim_set_keymap('n', '<A-Tab>', ':Neotree toggle<CR>', { noremap = true, silent = true })
