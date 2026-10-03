local luasnip = require("luasnip")
-- Shorthands
local s = luasnip.snippet
local sn = luasnip.snippet_node
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node
local c = luasnip.choice_node
local d = luasnip.dynamic_node
local r = luasnip.restore_node

local fmt = require("luasnip.extras.fmt").fmt
local utils = require("snippets.utils")

return {
	s(
		"slog",
		fmt(
			[[
              slog.Info("{}: ", "")
            ]],
			{
				-- It would be nice to use named keys here, but we get a weird position_so_far not found error when re-using
				-- the same formatting key
				d(1, utils.insert_file_name, {}, {}),
			}
		)
	),
	s(
		"slogd",
		fmt(
			[[
              slog.Debug("{}: ", "")
            ]],
			{
				-- It would be nice to use named keys here, but we get a weird position_so_far not found error when re-using
				-- the same formatting key
				d(1, utils.insert_file_name, {}, {}),
			}
		)
	),
}
