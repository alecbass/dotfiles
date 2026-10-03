local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local luasnip = require("luasnip")

cmp.setup({
	sources = cmp.config.sources({
		-- { name = "minuet" },
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	}, {
		{ name = "buffer" },
	}),
	-- performance = {
	-- 	fetching_timeout = 2000,
	-- },
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
		["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
		["<Enter>"] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete(),
		["<Tab>"] = nil,
		["<S-Tab>"] = nil,
		-- ["<A-y>"] = require("minuet").make_cmp_map(),
	}),
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
})
