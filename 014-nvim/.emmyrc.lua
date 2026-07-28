local config = {
	runtime = {
		version = "LuaLatest"
	},
	workspace = {
		library = {}
	}
}

local nvim_runtime_dir = os.getenv('NVIM_RUNTIME_DIR')
if nvim_runtime_dir then
	table.insert(config.workspace.library, nvim_runtime_dir)
end

local nvim_module_dir = os.getenv('NVIM_MODULE_DIR')
if nvim_module_dir then
	local pattern = string.format('[^%s]+', ':')
	for path in string.gmatch(nvim_module_dir, pattern) do
		table.insert(config.workspace.library, path)
	end
end

return config
