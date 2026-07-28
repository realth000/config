local status, _p = pcall(require, 'nvim-autopairs')
if (not status) then return end

---@module 'nvim-autopairs'
local plugin = _p

local config = { disable_filetype = { 'TelescopePrompt', 'vim' } }

plugin.setup(config)
