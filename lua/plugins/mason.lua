return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        require("mason").setup({
        ensure_installed =  {
          "clangd",
          "omnisharp",
      }
    })

        require("mason-lspconfig").setup({
            automatic_installation = true,
            ensure_installed = {
                "clangd",
                "omnisharp",
            },
        })

        require("mason-tool-installer").setup({
            ensure_installed = {
                "stylua", -- lua formatter
            },
        })
    end,
}

