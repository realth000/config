vim.b.custom_command_format_code_and_write = function()
	vim.cmd('%! nufmt --stdin')
	vim.cmd('write')
end

vim.opt_local.cinkeys:remove("0#")
vim.opt_local.indentkeys:remove("0#")
