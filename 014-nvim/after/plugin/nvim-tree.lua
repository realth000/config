local status, plugin = pcall(require, 'nvim-tree')
if (not status) then return end

-- nvim-tree 可以执行常见的 创建 、删除、拷贝、剪切 文件等操作
--
-- o 打开关闭文件夹
-- a 创建文件
-- r 重命名
-- x 剪切
-- c 拷贝
-- p 粘贴
-- d 删除

plugin.setup({
	sort = {
		sorter = 'case_sensitive',
	},
	renderer = {
		indent_markers = {
			enable = true
		}
	}
})
