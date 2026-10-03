local nvim_treesitter = require("nvim-treesitter")

nvim_treesitter.setup({
	-- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
	install_dir = vim.fn.stdpath("data") .. "/site",
})

-- At first launch, nvim_treesitter.install is nil for some reason
if nvim_treesitter.install ~= nil then
	nvim_treesitter.install({
		"lua",
		"vim",
		"vimdoc",
		"javascript",
		"typescript",
		"c",
		"cpp",
		"rust",
		"python",
		"jsx",
		"tsx",
		"go",
		"json",
		"yaml",
		"razor",
	})
end
