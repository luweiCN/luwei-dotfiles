-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- disable mouse
vim.opt.mouse = ""

-- 显示行号
vim.opt.number = true
vim.opt.relativenumber = true

-- 长文本自动换行
vim.opt.wrap = true
vim.opt.linebreak = true

-- 不可见字符
vim.opt.list = true -- 启用显示不可见字符
vim.opt.listchars = "space:·,tab:>-,trail:~,extends:>,precedes:<" -- 定义不可见字符的显示方式

--Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])
