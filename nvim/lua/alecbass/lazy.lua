-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local lazy = require("lazy")

local plugins = {
	{
		"nvim-telescope/telescope.nvim",
		version = "0.2.1",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		rev = "9a168f6357ed21c3a636e1727bc7d382abc451b8",
		lazy = false,
		build = ":TSUpdate",
	},
	{ "nvim-treesitter/nvim-treesitter-context", version = "1.0.0" },

	{ "mbbill/undotree", rev = "02b69aed427b848c4dca483fc5e9524b6019c296" },
	{ "tpope/vim-fugitive", rev = "3b753cf8c6a4dcde6edee8827d464ba9b8c4a6f0" },

	-- Lspconfig
	{ "neovim/nvim-lspconfig", version = "2.11.0" },

	-- Debugging
	{ "mfussenegger/nvim-dap", version = "0.10.0" },

	-- Colours
	{
		"rose-pine/neovim",
		name = "rose-pine",
		rev = "ff483051a47e27d84bdef47703538df1ed9f4a47",
	},

	-- Used for LSP completion windows
	{
		"hrsh7th/nvim-cmp",
		dependencies = "hrsh7th/cmp-nvim-lsp",
		rev = "2ffe79f1f021def8dd1fcd81deb16f1bb0d989f3",
	},
	{ "hrsh7th/cmp-nvim-lsp", rev = "cbc7b02bb99fae35cb42f514762b89b5126651ef" },

	-- Copilot
	-- { "github/copilot.vim" },
	{ "f-person/git-blame.nvim", rev = "5c536e2d4134d064aa3f41575280bc8a2a0e03d7" },

	-- Diagnostic Language server
	{
		"creativenull/diagnosticls-configs-nvim",
		tag = "v0.1.12", -- `tag` is optional
		dependencies = "neovim/nvim-lspconfig",
	},

	-- Telescope File Browser
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
		rev = "3610dc7dc91f06aa98b11dca5cc30dfa98626b7e",
	},

	-- neo-tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		version = "v3.41.0",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			{
				"s1n7ax/nvim-window-picker",
				version = "2.4.0",
				config = function()
					require("window-picker").setup({
						filter_rules = {
							include_current_win = false,
							autoselect_one = true,
							-- filter using buffer options
							bo = {
								-- if the file type is one of following, the window will be ignored
								filetype = { "neo-tree", "neo-tree-popup", "notify" },
								-- if the buffer type is one of following, the window will be ignored
								buftype = { "terminal", "quickfix" },
							},
						},
					})
				end,
			},
		},
		config = function()
			-- If you want icons for diagnostic errors, you'll need to define them somewhere:
			vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
			vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
			vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
			vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

			require("neo-tree").setup({
				close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
				popup_border_style = "rounded",
				enable_git_status = true,
				enable_diagnostics = true,
				enable_normal_mode_for_inputs = false, -- Enable normal mode for input dialogs.
				open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
				sort_case_insensitive = false, -- used when sorting files and directories in the tree
				sort_function = nil, -- use a custom function for sorting files and directories in the tree
				-- sort_function = function (a,b)
				--       if a.type == b.type then
				--           return a.path > b.path
				--       else
				--           return a.type > b.type
				--       end
				--   end , -- this sorts files and directories descendantly
				default_component_configs = {
					container = {
						enable_character_fade = true,
					},
					indent = {
						indent_size = 2,
						padding = 1, -- extra padding on left hand side
						-- indent guides
						with_markers = true,
						indent_marker = "│",
						last_indent_marker = "└",
						highlight = "NeoTreeIndentMarker",
						-- expander config, needed for nesting files
						with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
						expander_collapsed = "",
						expander_expanded = "",
						expander_highlight = "NeoTreeExpander",
					},
					icon = {
						folder_closed = "C",
						folder_open = "O",
						folder_empty = "E",
						-- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
						-- then these will never be used.
						default = "*",
						highlight = "NeoTreeFileIcon",
					},
					modified = {
						symbol = "[+]",
						highlight = "NeoTreeModified",
					},
					name = {
						trailing_slash = false,
						use_git_status_colors = true,
						highlight = "NeoTreeFileName",
					},
					git_status = {
						symbols = {
							-- Change type
							added = "➕", -- or "✚", but this is redundant info if you use git_status_colors on the name
							modified = "✏️", -- or "", but this is redundant info if you use git_status_colors on the name
							deleted = "✖", -- this can only be used in the git_status source
							renamed = "R", -- this can only be used in the git_status source
							-- Status type
							untracked = "U",
							ignored = "🕵️",
							unstaged = "👶",
							staged = "👟",
							conflict = "⚔️",
						},
					},
					-- If you don't want to use these columns, you can set `enabled = false` for each of them individually
					file_size = {
						enabled = true,
						required_width = 64, -- min width of window required to show this column
					},
					type = {
						enabled = true,
						required_width = 122, -- min width of window required to show this column
					},
					last_modified = {
						enabled = true,
						required_width = 88, -- min width of window required to show this column
					},
					created = {
						enabled = true,
						required_width = 110, -- min width of window required to show this column
					},
					symlink_target = {
						enabled = false,
					},
				},
				-- A list of functions, each representing a global custom command
				-- that will be available in all sources (if not overridden in `opts[source_name].commands`)
				-- see `:h neo-tree-custom-commands-global`
				commands = {},
				window = {
					position = "left",
					width = 40,
					mapping_options = {
						noremap = true,
						nowait = true,
					},
					mappings = {
						["<space>"] = {
							"toggle_node",
							nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
						},
						["<2-LeftMouse>"] = "open",
						["<cr>"] = "open",
						["<esc>"] = "cancel", -- close preview or floating neo-tree window
						["P"] = { "toggle_preview", config = { use_float = true } },
						["l"] = "focus_preview",
						["S"] = "open_split",
						["s"] = "open_vsplit",
						-- ["S"] = "split_with_window_picker",
						-- ["s"] = "vsplit_with_window_picker",
						["t"] = "open_tabnew",
						-- ["<cr>"] = "open_drop",
						-- ["t"] = "open_tab_drop",
						["w"] = "open_with_window_picker",
						--["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
						["C"] = "close_node",
						-- ['C'] = 'close_all_subnodes',
						["z"] = "close_all_nodes",
						--["Z"] = "expand_all_nodes",
						["a"] = {
							"add",
							-- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
							-- some commands may take optional config options, see `:h neo-tree-mappings` for details
							config = {
								show_path = "none", -- "none", "relative", "absolute"
							},
						},
						["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
						["d"] = "delete",
						["r"] = "rename",
						["y"] = "copy_to_clipboard",
						["x"] = "cut_to_clipboard",
						["p"] = "paste_from_clipboard",
						["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
						-- ["c"] = {
						--  "copy",
						--  config = {
						--    show_path = "none" -- "none", "relative", "absolute"
						--  }
						--}
						["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
						["q"] = "close_window",
						["R"] = "refresh",
						["?"] = "show_help",
						["<"] = "prev_source",
						[">"] = "next_source",
						["i"] = "show_file_details",
					},
				},
				nesting_rules = {},
				filesystem = {
					filtered_items = {
						visible = false, -- when true, they will just be displayed differently than normal items
						hide_dotfiles = false,
						hide_gitignored = false,
						hide_hidden = false, -- only works on Windows for hidden files/directories
						hide_by_name = {
							--"node_modules"
						},
						hide_by_pattern = { -- uses glob style patterns
							--"*.meta",
							--"*/src/*/tsconfig.json",
						},
						always_show = { -- remains visible even if other settings would normally hide it
							--".gitignored",
						},
						never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
							--".DS_Store",
							--"thumbs.db"
						},
						never_show_by_pattern = { -- uses glob style patterns
							--".null-ls_*",
						},
					},
					follow_current_file = {
						enabled = false, -- This will find and focus the file in the active buffer every time
						--               -- the current file is changed while the tree is open.
						leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
					},
					group_empty_dirs = false, -- when true, empty folders will be grouped together
					hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
					-- in whatever position is specified in window.position
					-- "open_current",  -- netrw disabled, opening a directory opens within the
					-- window like netrw would, regardless of window.position
					-- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
					use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
					-- instead of relying on nvim autocmd events.
					window = {
						mappings = {
							["<bs>"] = "navigate_up",
							["."] = "set_root",
							["H"] = "toggle_hidden",
							["/"] = "fuzzy_finder",
							["D"] = "fuzzy_finder_directory",
							["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
							-- ["D"] = "fuzzy_sorter_directory",
							["f"] = "filter_on_submit",
							["<c-x>"] = "clear_filter",
							["[g"] = "prev_git_modified",
							["]g"] = "next_git_modified",
							["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
							["oc"] = { "order_by_created", nowait = false },
							["od"] = { "order_by_diagnostics", nowait = false },
							["og"] = { "order_by_git_status", nowait = false },
							["om"] = { "order_by_modified", nowait = false },
							["on"] = { "order_by_name", nowait = false },
							["os"] = { "order_by_size", nowait = false },
							["ot"] = { "order_by_type", nowait = false },
						},
						fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
							["<down>"] = "move_cursor_down",
							["<C-n>"] = "move_cursor_down",
							["<up>"] = "move_cursor_up",
							["<C-p>"] = "move_cursor_up",
						},
					},

					commands = {}, -- Add a custom command or override a global one using the same function name
				},
				buffers = {
					follow_current_file = {
						enabled = true, -- This will find and focus the file in the active buffer every time
						--              -- the current file is changed while the tree is open.
						leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
					},
					group_empty_dirs = true, -- when true, empty folders will be grouped together
					show_unloaded = true,
					window = {
						mappings = {
							["bd"] = "buffer_delete",
							["<bs>"] = "navigate_up",
							["."] = "set_root",
							["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
							["oc"] = { "order_by_created", nowait = false },
							["od"] = { "order_by_diagnostics", nowait = false },
							["om"] = { "order_by_modified", nowait = false },
							["on"] = { "order_by_name", nowait = false },
							["os"] = { "order_by_size", nowait = false },
							["ot"] = { "order_by_type", nowait = false },
						},
					},
				},
				git_status = {
					window = {
						position = "float",
						mappings = {
							["A"] = "git_add_all",
							["gu"] = "git_unstage_file",
							["ga"] = "git_add_file",
							["gr"] = "git_revert_file",
							["gc"] = "git_commit",
							["gp"] = "git_push",
							["gg"] = "git_commit_and_push",
							["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
							["oc"] = { "order_by_created", nowait = false },
							["od"] = { "order_by_diagnostics", nowait = false },
							["om"] = { "order_by_modified", nowait = false },
							["on"] = { "order_by_name", nowait = false },
							["os"] = { "order_by_size", nowait = false },
							["ot"] = { "order_by_type", nowait = false },
						},
					},
				},
			})

			vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
		end,
	},

	-- Tabby
	{ "nanozuki/tabby.nvim", version = "2.8.1" },

	-- Bufferline
	{ "akinsho/bufferline.nvim", version = "v4.9.1", dependencies = "nvim-tree/nvim-web-devicons" },

	-- Conform
	{ "stevearc/conform.nvim", version = "v9.1.0", rev = "fbcb4fa7f34bfea9be702ffff481a8e336ebf6ed" },

	-- Commenting
	{
		"numToStr/Comment.nvim",
		rev = "e30b7f2008e52442154b66f7c519bfd2f1e32acb",
	},

	-- Statusline
	{
		"nvim-lualine/lualine.nvim",
		rev = "221ce6b2d999187044529f49da6554a92f740a96",
		dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
	},

	-- Indentation selection
	{
		"michaeljsmith/vim-indent-object",
		rev = "8ab36d5ec2a3a60468437a95e142ce994df598c6",
	},

	-- Snippets
	{
		"L3MON4D3/LuaSnip",
		version = "v2.5.0",
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
	},
	{ "rafamadriz/friendly-snippets", rev = "6cd7280adead7f586db6fccbd15d2cac7e2188b9" },
	-- Allows luasnip snippets to appear in nvim-cmp
	{ "saadparwaiz1/cmp_luasnip", rev = "98d9cb5c2c38532bd9bdb481067b20fea8f32e90" },

	-- Grepic Nick recursive reference finder
	{
		"trkl-dev/references.nvim",
		rev = "64823f9b07bececf81524d104273bf84c0a6327a",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			local references = require("references")

			-- NOTE: This replaces the remap <leader>vrr binding
			vim.keymap.set("n", "<leader>vrr", references.recursive_references, {})
		end,
	},
	-- For `plugins/markview.lua` users.
	{
		"OXY2DEV/markview.nvim",
		version = "v28.3.0",
		lazy = false,

		-- Completion for `blink.cmp`
		-- dependencies = { "saghen/blink.cmp" },
	},

	-- Local code autocomplete
	{
		"milanglacier/minuet-ai.nvim",
		version = "0.10.0",
	},
}

lazy.setup(plugins, opts)
