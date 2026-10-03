vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Disable arrows for learning
vim.keymap.set("n", "<Left>", "<nop>")
vim.keymap.set("n", "<Right", "<nop>")
vim.keymap.set("n", "<Up>", "<nop>")
vim.keymap.set("n", "<Down>", "<nop>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Capital Q is "the worst place in the universe"
vim.keymap.set("n", "Q", "<nop>")

-- LSPSaga
vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>")

-- From Nick
-- vim.keymap.set("n", "K", function()
-- 	vim.lsp.buf.hover()
-- end, opts)
vim.keymap.set("n", "<leader>vws", function()
	vim.lsp.buf.workspace_symbol()
end, opts)
vim.keymap.set("n", "<leader>vd", function()
	vim.diagnostic.open_float()
end, opts)
vim.keymap.set("n", "<leader>vca", function()
	vim.lsp.buf.code_action()
end, opts)
vim.keymap.set("n", "<leader>vrr", function()
	vim.lsp.buf.references()
end, opts)
vim.keymap.set("n", "<leader>vrn", function()
	vim.lsp.buf.rename()
end, opts)
vim.keymap.set("n", "<leader><C-h>vrn", function()
	vim.lsp.buf.signature_help()
end, opts)

function GoToMainWindow()
    local windows = vim.api.nvim_tabpage_list_wins(0)
    local main_window = windows[#windows] -- Right-most, which at the time of writing is the window with code

    vim.api.nvim_set_current_win(main_window)
end

vim.keymap.set("n", "<leader>gw", GoToMainWindow)
