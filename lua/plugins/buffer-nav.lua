local M = {}

-- Function to open the previous buffer
local function open_previous_buffer()
  local all_buffers = vim.api.nvim_list_bufs()

  local visible_buffers = {}
  for _, buf in ipairs(all_buffers) do
      if vim.bo[buf].buflisted then
          table.insert(visible_buffers, buf)
      end
  end

  local current_buffer = vim.api.nvim_get_current_buf()
  local current_index = nil

  for i, buf in ipairs(visible_buffers) do
    if buf == current_buffer then
      current_index = i
      break
    end
  end

  if current_index == nil then
    vim.cmd('enew') -- Create a new empty buffer
    return
  end

  -- Try to switch to the previous buffers first
  for i = current_index - 1, 1, -1 do
    if vim.api.nvim_buf_is_loaded(visible_buffers[i]) then
      vim.api.nvim_set_current_buf(visible_buffers[i])
      return
    end
  end

  -- If no previous buffers are available, try the next buffers
  for i = current_index + 1, #visible_buffers do
    if vim.api.nvim_buf_is_loaded(visible_buffers[i]) then
      vim.api.nvim_set_current_buf(visible_buffers[i])
      return
    end
  end

  vim.cmd('enew') -- Create a new empty buffer if no other buffers are available
end

-- Function to close the current buffer without saving
M.quit_without_saving = function()
  local current_buf = vim.api.nvim_get_current_buf()
  if not vim.bo[current_buf].buflisted then
    return
  end
  open_previous_buffer()
  vim.api.nvim_buf_delete(current_buf, { force = true })
end

-- Function to close the current buffer after saving
M.quit_after_saving = function()
  local current_buf = vim.api.nvim_get_current_buf()
   if not vim.bo[current_buf].buflisted then
    return
  end
 
  if M.can_save_buf(current_buf) then
    vim.cmd('write')  -- Save the current buffer
  end

  open_previous_buffer()
  vim.api.nvim_buf_delete(current_buf, { force = true })
end

-- Function to move to the next buffer
M.move_to_next_buffer = function()
  local current_buf = vim.api.nvim_get_current_buf()
  if not vim.bo[current_buf].buflisted then
    return
  end

 vim.cmd('bnext')
end

-- Function to move to the previous buffer
M.move_to_previous_buffer = function()
  local current_buf = vim.api.nvim_get_current_buf()
  if not vim.bo[current_buf].buflisted then
    return
  end

  vim.cmd('bprevious')
end

M.can_save_buf = function(bufnr)
    -- Get the file name associated with the buffer
    local file_name = vim.api.nvim_buf_get_name(bufnr)

    -- Check if the buffer is modified and has a file associated with it
    if file_name == "" then
        return false -- No file associated with the buffer
    end

    -- Use Vim's `filereadable()` function to check if the file exists on disk
    local file_exists = vim.fn.filereadable(file_name) == 1

    -- Check if the buffer is loaded (has data that can be saved)
    local is_loaded = vim.api.nvim_buf_is_loaded(bufnr)

    -- The buffer can be saved if it has a valid file name, the file exists on disk, and it's loaded
    return is_loaded and file_exists
end

-- Setup function to map keys
function M.setup(options)
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

