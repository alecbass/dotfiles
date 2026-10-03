local conform = require("conform")

local python_formatter = os.getenv("CONFORM_PYTHON_FORMATTER")

-- Default to ruff if no python formatter is set
if python_formatter == nil then
	python_formatter = "ruff_format"
end

local js_formatter = os.getenv("CONFORM_JAVASCRIPT_FORMATTER")

-- Default to Prettier if no JavaScript formatter is set
if js_formatter == nil then
	js_formatter = "prettier"
end

conform.setup({
	formatters_by_ft = {
		html = { "djlint" },
		lua = { "stylua" }, -- Install with `cargo install stylua`
		-- Conform will run multiple formatters sequentially
		python = { python_formatter },
		-- Use a sub-list to run only the first available formatter
		javascript = { js_formatter },
		javascriptreact = { js_formatter },
		typescript = { js_formatter },
		typescriptreact = { js_formatter },
		css = { js_formatter },
		rust = { "rustfmt" },
		go = { "gofmt" },
		terraform = { "terraform_fmt" },
		tf = { "terraform_fmt" },
		["terraform-vars"] = { "terraform_fmt" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		nix = { "nixfmt" },
	},
})

-- conform.formatters.djlint = {
--     append_args = { "--reformat" } -- Save the file after format
-- }

conform.formatters.ruff_format = {
	append_args = { "--line-length=120" },
}
