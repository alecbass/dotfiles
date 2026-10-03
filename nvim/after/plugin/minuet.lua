local should_run_minuet = os.getenv("NEOVIM_RUN_MINUET") == "1"

if not should_run_minuet then
	return
end

require("minuet").setup({
	virtualtext = {
		auto_trigger_ft = {
			"lua",
			"rust",
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
			"html",
			"css",
			"python",
			"go",
			"sh",
			"bash",
			"markdown",
			"c",
			"cpp",
			"csharp",
			"cs",
            "razor",
			"nix",
		},
		keymap = {
			-- accept whole completion
			accept = "<Tab>", -- "<A-A>",
			-- accept one line
			accept_line = "<A-a>",
			-- accept n lines (prompts for number)
			-- e.g. "A-z 2 CR" will accept 2 lines
			accept_n_lines = "<A-z>",
			-- Cycle to prev completion item, or manually invoke completion
			prev = "<A-[>",
			-- Cycle to next completion item, or manually invoke completion
			next = "<A-]>",
			dismiss = "<A-e>",
		},
		-- Whether show virtual text suggestion when the completion menu
		-- (nvim-cmp or blink-cmp) is visible.
		show_on_completion_menu = true,
	},
	-- lsp = {
	-- 	enabled_ft = { "toml", "lua", "cpp" },
	-- 	completion = {
	-- 		-- Enables automatic completion triggering using `vim.lsp.completion.enable`
	-- 		enabled_auto_trigger_ft = { "cpp", "lua" },
	-- 	},
	-- },
	n_completions = 1, -- recommend for local model for resource saving
	-- provider = "openai_fim_compatible",
	-- n_completions = 1, -- recommend for local model for resource saving
	-- -- I recommend beginning with a small context window size and incrementally
	-- -- expanding it, depending on your local computing power. A context window
	-- -- of 512, serves as an good starting point to estimate your computing
	-- -- power. Once you have a reliable estimate of your local computing power,
	-- -- you should adjust the context window to a larger value.
	-- context_window = 512,

	--
	-- llama.cpp
	--
	provider = "openai_fim_compatible",
	provider_options = {
		openai_fim_compatible = {
			-- For Windows users, TERM may not be present in environment variables.
			-- Consider using APPDATA instead.
			api_key = "TERM",
			name = "Llama.cpp",
			end_point = "http://localhost:8012/v1/completions",
			-- The model is set by the llama-cpp server and cannot be altered
			-- post-launch.
			model = "PLACEHOLDER",
			optional = {
				max_tokens = 128, -- 56,
				top_p = 0.9,
			},
			-- Llama.cpp does not support the `suffix` option in FIM completion.
			-- Therefore, we must disable it and manually populate the special
			-- tokens required for FIM completion.
			template = {
				prompt = function(context_before_cursor, context_after_cursor, _)
					return "<|fim_prefix|>"
						.. context_before_cursor
						.. "<|fim_suffix|>"
						.. context_after_cursor
						.. "<|fim_middle|>"
				end,
				suffix = false,
			},
			transform = {},
		},
	},

	--
	-- Opencode
	--
	-- provider = "openai_compatible",
	-- request_timeout = 2.5,
	-- throttle = 1500, -- Increase to reduce costs and avoid rate limits
	-- debounce = 600, -- Increase to reduce costs and avoid rate limits
	-- provider_options = {
	-- 	openai_compatible = {
	-- 		api_key = function()
	-- 			return os.getenv("OPENCODE_GO_API_KEY")
	-- 		end,
	-- 		end_point = "https://opencode.ai/zen/go/v1/chat/completions",
	-- 		-- model = "glm-5.3",
	-- 		-- model = "deepseek-v4-flash",
	-- 		model = "kimi-k2.7-code",
	-- 		name = "Opencode",
	-- 		optional = {
	-- 			max_tokens = 56,
	-- 			-- top_p = 0.9,
	--                top_p = 0.95,
	-- 			-- disable thinking to avoid first token latency
	-- 			thinking = { type = "enabled" },
	-- 		},
	-- 		-- Custom HTTP headers must go through `transform`; `optional` is request body only
	-- 		transform = {
	-- 			function(args)
	-- 				args.headers["x-opencode-session"] = "nvim"
	-- 				return args
	-- 			end,
	-- 		},
	-- 	},
	-- },
})
