return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        {
            "blakekrpec/nvim-dap",
            branch = "add-optional-args"
        },
        "nvim-neotest/nvim-nio"
    },

    config = function()
        require("dapui").setup()
    end
}
