local capabilities = require("cmp_nvim_lsp").default_capabilities()
local conform = require("conform")

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		local bufnr = event.buf
		local opts = { buffer = event.buf }

		-- these will be buffer-local keybindings
		-- because they only work if you have an active language server

		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		-- vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts) Replaced with Telescope currently
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<leader><F2>", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>f", function()
			conform.format({ bufnr = bufnr })
		end, opts)
		vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)
	end,
})

--
-- Python
--

-- https://docs.basedpyright.com/latest/
vim.lsp.config("basedpyright", {
	capabilities = capabilities,
	settings = {
		basedpyright = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = true,
				typeCheckingMode = "standard",
				diagnosticSeverityOverrides = {
					reportWildcardImportFromLibrary = "none",
					reportUnknownMemberType = "none",
					reportUnannotatedClassAttribute = "none",
					reportMissingTypeStubs = "none",
				},
				inlayHints = {
					callArgumentNames = true,
					variableTypes = true,
					enumMemberValues = true,
					functionReturnTypes = true,
					genericTypes = true,
				},
			},
		},
	},
})
vim.lsp.enable("basedpyright")

-- Install with `pip install pytest-language-server`
vim.lsp.enable("pytest_language_server")

vim.lsp.config("ruff", {
	capabilities = capabilities,
	init_options = {
		settings = {
			-- Any extra CLI arguments for `ruff` go here.
			args = {
				"--line-length=120",
			},
			-- organizeImports = false,
			-- ["lint.run"] = "onSave",
			["ruff.configuration"] = "./pyproject.toml",
			lineLength = 120,
			configuration = "./pyproject.toml",
			configurationPreference = "filesystemFirst",
		},
	},
})

vim.lsp.enable("ruff")

--
-- JavaScript / TypeScript
--
--

local typescript_dir = os.getenv("LOCAL_TYPESCRIPT_TSDK")

vim.lsp.config("vtsls", {
	capabilities = capabilities,
	settings = {
		typescript = {
			tsdk = typescript_dir,
			inlayHints = {
				parameterNames = { enabled = "literals" },
				parameterTypes = { enabled = true },
				variableTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				enumMemberValues = { enabled = true },
			},
		},
		autoUseWorkspaceTsdk = true,
	},
})
vim.lsp.enable("vtsls")

local js_formatter = os.getenv("CONFORM_JAVASCRIPT_FORMATTER")

-- Default to Prettier if no JavaScript formatter is set
if js_formatter == "eslint" then
	local eslint_base_on_attach = vim.lsp.config.eslint.on_attach

	vim.lsp.config("eslint", {
		on_attach = function(client, bufnr)
			if not eslint_base_on_attach then
				return
			end

			eslint_base_on_attach(client, bufnr)
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				command = "LspEslintFixAll",
			})
		end,
	})

	vim.lsp.enable("eslint")
end

--
-- Rust
--

vim.lsp.config("rust_analyzer", {
	capabilities = capabilities, -- Required for make import suggestions appear
	settings = {
		["rust-analyzer"] = {
			diagnostics = {
				enable = true,
			},
			cargo = {
				buildScripts = {
					enable = true,
				},
				features = "all",
				allFeatures = true,
			},
			procMacro = {
				enable = true,
			},
		},
	},
})
vim.lsp.enable("rust_analyzer")

--
-- Go
--

vim.lsp.config("gopls", {
	capabilities = capabilities,
})
vim.lsp.enable("gopls")

vim.filetype.add({ extension = { templ = "templ" } })

vim.lsp.config("templ", {
	on_attach = function(client, bufnr)
		-- Do nothing for now
	end,
})
vim.lsp.enable("templ")

--
-- Diagnostic Language Server
--
local prettier = require("diagnosticls-configs.formatters.prettier")
local black = require("diagnosticls-configs.formatters.black")
local luacheck = require("diagnosticls-configs.linters.luacheck")

vim.lsp.config("diagnosticls", {
	filetypes = { "*" },
	init_options = {
		linters = {
			ligma = {
				command = "/Users/nickhenderson/Projects/Ligma/ligma.py",
				sourceName = "python3",
				args = { "%filepath" },
				formatPattern = {
					"^(\\d+):(\\d+):(\\d+):([^:]+):([^:]+)$",
					{
						line = 1,
						column = 2,
						endColumn = 3,
						security = 4,
						message = 5,
					},
				},
				securities = {
					info = "info",
				},
			},
		},
		filetypes = {
			["*"] = { "ligma" },
			["javascript"] = "eslint",
			["javascriptreact"] = "eslint",
			-- Don't use "typescript" or "typescript" as weird local babel configurations mess it up
			["lua"] = "luacheck",
		},
	},
})
vim.lsp.enable("diagnosticls")

--
-- Bash
--
vim.lsp.config("bashls", {
	capabilities = capabilities,
})
vim.lsp.enable("bashls")

--
-- Django
--

vim.lsp.config("djlsp", {
	filetypes = { "htmldjango" },
	capabilities = capabilities,
})
vim.lsp.enable("djlsp")

--
-- HTML
--
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config("html", {
	capabilities = capabilities,
	filetypes = { "html", "htmldjango", "templ", "razor" },
})
vim.lsp.enable("html")

-- Styling (CSS/SCSS)

vim.lsp.config("cssls", {
	capabilities = capabilities,
})
vim.lsp.enable("cssls")

--
-- HTMX
--

vim.lsp.config("htmx", {
	capabilities = capabilities,
	filetypes = { "html", "htmldjango", "razor" },
})
vim.lsp.enable("htmx")

-- JSON
vim.lsp.config("jsonls", {
	capabilities = capabilities,
})
vim.lsp.enable("jsonls")

--
-- Docker Compose
--
vim.lsp.config("docker_compose_language_service", {
	capabilities = capabilities,
})
vim.lsp.enable("docker_compose_language_service")

--
-- Docker
--
vim.lsp.config("docker_language_server", {
	capabilities = capabilities,
})
vim.lsp.enable("docker_language_server")

--
-- C/C++/Objective-C and Swift

vim.lsp.config("sourcekit", {
	-- filetypes = {
	--     -- "swift",
	--     "c",
	--     "cpp",
	--     -- "objective-c",
	--     -- "objective-cpp"
	-- },
	capabilities = {
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = true,
			},
		},
	},
})
vim.lsp.enable("sourcekit")

vim.lsp.config("clangd", {
	capabilities = capabilities,
})
vim.lsp.enable("clangd")

--
-- SQL
--

-- lspconfig.sqls.setup({
--   capabilities = capabilities,
--   on_attach = function(client, bufnr)
--     require("sqls").on_attach(client, bufnr) -- require sqls.nvim
--   end,
--   settings = {
--     sqls = {
--       connections = {
--         {
--           driver = "postgresql",
--           -- DropSpot specific
--           dataSourceName = "host=127.0.0.1 port=5432 user=dropspot password=dropspot dbname=dropspot sslmode=disable",
--         },
--       },
--     },
--   },
-- })

vim.lsp.config("postgres_lsp", {
	capabilities = capabilities,
})
vim.lsp.enable("postgres_lsp")

--
-- Lua
--

vim.lsp.config("lua_ls", {
	capabilities = capabilities,
})
vim.lsp.enable("lua_ls")

--
-- Dotnet (C#)
--

-- C# and Razor
vim.lsp.config("roslyn_ls", {
	filetypes = { "cs", "razor" },
	settings = {
		["csharp|inlay_hints"] = {
			csharp_enable_inlay_hints_for_implicit_object_creation = true,
			csharp_enable_inlay_hints_for_implicit_variable_types = true,
			csharp_enable_inlay_hints_for_lambda_parameter_types = true,
			csharp_enable_inlay_hints_for_types = true,
			dotnet_enable_inlay_hints_for_indexer_parameters = true,
			dotnet_enable_inlay_hints_for_literal_parameters = true,
			dotnet_enable_inlay_hints_for_object_creation_parameters = true,
			dotnet_enable_inlay_hints_for_other_parameters = true,
			dotnet_enable_inlay_hints_for_parameters = true,
			dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
			dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
			dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
		},
		["csharp|code_lens"] = {
			dotnet_enable_references_code_lens = true,
		},
		["csharp|completion"] = {
			dotnet_provide_regex_completions = true,
			dotnet_show_completion_items_from_unimported_namespaces = true,
			dotnet_show_name_completion_suggestions = true,
		},
	},
})
vim.lsp.enable("roslyn_ls")

--
-- Terraform
--

vim.lsp.config("terraformls", {
	capabilities = capabilities,
})
vim.lsp.enable("terraformls")

--
-- Arduino
--
vim.lsp.config("arduino_language_server", {
	capabilities = capabilities,
})
vim.lsp.enable("arduino_language_server")

--
-- Nix
--
vim.lsp.enable("nixd")

--
-- YAML
--
vim.lsp.enable("yamlls")
