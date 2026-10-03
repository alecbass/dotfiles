local formatters = {
	autoflake = {
		command = "autoflake",
		args = { "--quiet", "-" },
		rootPatterns = { "pyproject.toml" },
	},

	black = {
		command = "black",
		args = { "--quiet", "-" },
		rootPatterns = { "pyproject.toml" },
	},

	isort = {
		command = "isort",
		args = { "--quiet", "-" },
		rootPatterns = { "pyproject.toml", ".isort.cfg" },
	},

	pg_format = {
		command = "pg_format",
		-- https://github.com/darold/pgFormatter/issues/250
		args = { "--config", ".pg_format" },
		-- args = { "-B", "-L" },
		rootPatterns = { ".pg_format" },
		requiredFiles = { ".pg_format" },
	},

	prettier = {
		command = "./node_modules/.bin/prettier",
		args = { "--stdin", "--stdin-filepath", "%filepath" },
		rootPatterns = {
			".prettierrc",
			".prettierrc.json",
			".prettierrc.toml",
			".prettierrc.json",
			".prettierrc.yml",
			".prettierrc.yaml",
			".prettierrc.json5",
			".prettierrc.js",
			".prettierrc.cjs",
			"prettier.config.js",
			"prettier.config.cjs",
		},
	},

	shfmt = {
		command = "shfmt",
		args = { "-filename", "%filepath" },
		rootPatterns = { ".editorconfig" },
	},
}

return formatters
