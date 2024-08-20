return {
  {
    "buffer-nav",
    dir = "~/.config/nvim/lua/plugins/buffer-nav.lua",
    config = function()
      require("plugins.buffer-nav").setup({
        ignored_buffers = {"neo-tree"}
      })
    end
  }
}
