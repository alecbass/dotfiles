local luasnip = require("luasnip")
-- Shorthands
local sn = luasnip.snippet_node
local t = luasnip.text_node

local M = {}

-- Gets the current file name, without its extension
function M.get_file_name()
	-- The path to this file from the nvim config root
	local path = string.gsub(vim.api.nvim_buf_get_name(0), vim.loop.cwd(), "")

	local file_name = ""
	-- Iterate over every directory until we get to the last element: the file name
	-- i.e. /after/plugin/luasnip.lua -> { "after", "plugin", "luasnip.lua" }
	for token, _ in string.gmatch(path, "[^/%s]+") do
		file_name = token
	end

	-- i.e. luasnip.
	local name = string.gmatch(file_name, "[^%s$].+[\\.]")

	local name_without_extension = ""
	for name_section in name do
		-- Cut off the trailing dot
		local length = string.len(name_section)
		name_without_extension = string.sub(name_section, 1, length - 1)

		break
	end

	return name_without_extension
end

-- Transforms "cool-component" into "CoolComponent"
function M.create_class_name(file_name)
	-- Capitalised class name
	local class_name = ""

	-- Used to know if we reach a '-' OR at the first character, which should be capitalised
	local should_capitalise_next_char = true

	-- Iterate character-by-character, ignoring dashes and capitalising the next character when we see one
	for index = 1, #file_name do
		local char = file_name:sub(index, index)
		local should_skip = char == "-"

		if should_capitalise_next_char then
			char = char:upper()
			should_capitalise_next_char = false
		end

		if should_skip == false then
			class_name = class_name .. char
		else
			-- No continue statement in lua :(
			should_capitalise_next_char = true
		end
	end

	return class_name
end

function M.insert_file_name(args, snip, old_state, user_args)
	-- Just use the file name
	local file_name = M.get_file_name()

	return sn(nil, t(file_name))
end

function M.insert_class_name(args, snip, old_state, user_args)
	-- Transform the file name into both a class name, and a tag name
	-- cool-component.ts -> CoolComponent
	local file_name = M.get_file_name()
	local class_name = M.create_class_name(file_name) .. "Element"

	return sn(nil, t(class_name))
end

function M.insert_tag_name(args, snip, old_state, user_args)
	-- Just use the file name
	local file_name = M.get_file_name()

	return sn(nil, t(file_name))
end

return M
