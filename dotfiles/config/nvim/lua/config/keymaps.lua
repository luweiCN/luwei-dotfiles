-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local discipline = require("luwei/discipline")
discipline.cowboy()

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

--- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")
---
--- Delete a word backwardds
keymap.set("n", "dw", "vb_d")

--- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

--- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- new tab
keymap.set("n", "te", ":tabedit ", opts)
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
keymap.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>sf", ":saveas ", opts)

--- Split Window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

--- Move Window
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
--- Resize Window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")
keymap.set("n", "<C-w>m", "<leader>wm") -- toggle split window maximization

--- Diagnostics
keymap.set("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end, opts)

--- open code map(代码缩略图)
keymap.set("n", "<C-c>m", ":SymbolsOutline<CR>", opts)

--- 使用kj在视觉行中上下移动，而不是物理行。
keymap.set("n", "k", "gk", { noremap = true, silent = true })
keymap.set("n", "j", "gj", { noremap = true, silent = true })
