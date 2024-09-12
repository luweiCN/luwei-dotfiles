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

-- 全局诊断配置
vim.diagnostic.config({
  underline = true,
  signs = true,
  update_in_insert = true,
  severity_sort = true,
  virtual_text = {
    spacing = 4,
    prefix = "",
    format = function(diagnostic)
      -- 获取当前缓冲区的所有诊断信息
      local bufnr = diagnostic.bufnr
      local all_diagnostics = vim.diagnostic.get(bufnr)

      --先按照诊断优先级排序，重要的排在前面
      table.sort(all_diagnostics, function(a, b)
        return a.severity > b.severity
      end)

      -- TODO: 同一行只展示优先级最高的诊断信息

      local diagnostic_prefixs = {
        [vim.diagnostic.severity.ERROR] = "(Error  )",
        [vim.diagnostic.severity.WARN] = "(Warning  )",
        [vim.diagnostic.severity.INFO] = "(Info  )",
        [vim.diagnostic.severity.HINT] = "(Hint  )",
      }

      local diagnostic_prefix = diagnostic_prefixs[diagnostic.severity]
      return string.format("%s[%s] %s", diagnostic_prefix, diagnostic.source, diagnostic.message)
    end,
  },
})
