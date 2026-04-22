return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if not ok then return end
    configs.setup({
      ensure_installed = {
        "lua",
        "python",
        "cpp",
        "c_sharp",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
    })
  end,
}
