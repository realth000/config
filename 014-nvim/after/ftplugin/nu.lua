vim.b.custom_command_format_code_and_write = function ()
	if vim.fn.executable('nufmt') ~= 1 then
		return 'nufmt command not found'
	end

	vim.cmd('%! nufmt --stdin')
	vim.cmd('write')

	return nil
end
