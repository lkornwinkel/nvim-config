local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPost",
  dependencies = {},

  opts = {
    ensure_installed = { "cpp" },
  },
}

return M
