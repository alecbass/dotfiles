local markview = require("markview")

markview.setup({
    preview = {
        enable = false
    }
});

vim.keymap.set("n", "<leader>md", function()
    vim.cmd("Markview")
end)
