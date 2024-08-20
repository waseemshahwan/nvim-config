-- close_buffers.lua

local M = {}

-- Function to open the previous buffer
local function open_previous_buffer()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()
  local prev_buf = nil

  for _, buf in ipairs(buffers) do
    if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) and not M.is_buf_ignored(buf) then
      print("is buf ignored:")
      print(M.is_buf_ignored(buf))
      vim.api.nvim_set_current_buf(buf)
      return
    end
  end

  vim.cmd('enew') -- Create a new empty buffer
end

-- Function to close the current buffer without saving
M.quit_without_saving = function()
  local current_buf = vim.api.nvim_get_current_buf()
  open_previous_buffer()
  vim.api.nvim_buf_delete(current_buf, { force = true })
end

-- Function to close the current buffer after saving
M.quit_after_saving = function()
  local current_buf = vim.api.nvim_get_current_buf()
  vim.cmd('write')  -- Save the current buffer
  open_previous_buffer()
  vim.api.nvim_buf_delete(current_buf, { force = true })
end

-- Function to move to the next buffer
M.move_to_next_buffer = function()
  vim.cmd('bnext')
end

-- Function to move to the previous buffer
M.move_to_previous_buffer = function()
  vim.cmd('bprevious')
end

M.is_buf_ignored = function(buf)
  print(vim.api.nvim_buf_get_name(buf))

  print(buf)
  return false
end

-- Setup function to map keys
M.setup = function()
  vim.api.nvim_set_keymap(
    'n',
    '<leader>q',
    ':lua require("plugins.buffer-nav").quit_without_saving()<CR>',
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    'n',
    '<leader>w',
    ':lua require("plugins.buffer-nav").quit_after_saving()<CR>',
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    'n',
    '<Tab>',
    ':lua require("plugins.buffer-nav").move_to_next_buffer()<CR>',
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    'n',
    '<S-Tab>',
    ':lua require("plugins.buffer-nav").move_to_previous_buffer()<CR>',
    { noremap = true, silent = true }
  )
end

return M
