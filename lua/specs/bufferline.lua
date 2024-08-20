return {
  {
    'akinsho/bufferline.nvim',
    version = "*",
    depedencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      vim.opt.termguicolors = true
      require("bufferline").setup({
        options = {
          offsets = {
            {
              filetype = "neo-tree",
              text = "Nvim Tree",
              separator = true,
              text_align = "left",
            }
          },
          separator_style = {"",""},
          modified_icon = "●",
          show_close_icon = false,
          show_buffer_close_icons = true,
        }
      })
    end,
  }
}
