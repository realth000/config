---@param target string -- Target char to act
---@param insert boolean -- Set to insert mode after action or not
---@param removeTarget boolean -- Remove [target] or not
local function updateContent(target, insert, removeTarget)
	local cursor_row = vim.api.nvim_win_get_cursor(0)[1]
	local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
	local start_pos = math.max(0, cursor_row - 1)
	local end_pos = math.max(0, cursor_row)
	local buffer_rows = vim.api.nvim_buf_get_lines(0, start_pos, end_pos, false)
	local ret = ''
	---@type integer|nil
	local delete_start_pos
	---@type integer|nil
	local delete_end_pos

	local buffer_text = ''
	for _, v in ipairs(buffer_rows) do
		buffer_text = buffer_text .. v
	end

	local find_pos = 1
	while true do
		local x, y = string.find(buffer_text, target, find_pos, true)
		if x == nil then break end
		if x <= cursor_col then
			delete_start_pos = y
		end
		if x > cursor_col and delete_end_pos == nil then
			delete_end_pos = y
		end

		if delete_start_pos ~= nil and delete_end_pos ~= nil then
			if removeTarget then
				delete_start_pos = math.max(1, delete_start_pos - 1)
				delete_end_pos = delete_end_pos + 1
			end
			ret = buffer_text:sub(1, delete_start_pos) .. buffer_text:sub(delete_end_pos)
			vim.api.nvim_buf_set_lines(0, cursor_row, cursor_row, true, { ret })
			vim.cmd('delete')
			if insert then
				vim.cmd('startinsert')
			end

			vim.api.nvim_win_set_cursor(0, { cursor_row, delete_start_pos })
			break
		end
		find_pos = y + 1
	end
end

--Implement di_
---@param target string
function DeleteInsert(target)
	updateContent(target, false, false)
end

--Implement da_
---@param target string
function DeleteAppend(target)
	updateContent(target, false, true)
end

--Implement ci_
---@param target string
function ChangeInsert(target)
	updateContent(target, true, false)
end

--Implement ca_
---@param target string
function ChangeAppend(target)
	updateContent(target, true, true)
end
