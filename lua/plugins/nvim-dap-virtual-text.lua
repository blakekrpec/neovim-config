return {
    "theHamsta/nvim-dap-virtual-text",
    requires = {
        "blakekrpec/nvim-dap",
        branch = "add-optional-args"
    },
    config = function()
        require("nvim-dap-virtual-text").setup()
    end
}
