vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("i", "jk", "<ESC>")

vim.api.nvim_set_keymap("n", "i", "a", { noremap = true })
--- Split navigation

vim.keymap.set("n", "<leader>sv", "<C-w>v") -- split vertical
vim.keymap.set("n", "<leader>sh", "<C-w>s") -- split horizontal
vim.keymap.set("n", "<leader>se", "<C-w>=") -- equalize splits
vim.keymap.set("n", "<leader>sx", ":close<CR>") -- close current window

-- Tab navigation
vim.keymap.set("n", "<leader>to", ":tabnew<CR>") -- new tabnew
vim.keymap.set("n", "<leader>tx", ":tabClose<CR>") -- close the current tab
vim.keymap.set("n", "<leader>tn", ":tabn<CR>") -- next tab
vim.keymap.set("n", "<leader>tp", ":tabp<CR>") -- previous tab

vim.api.nvim_set_keymap("n", "<C-p>", ":m .-2<CR>==", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-n>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-n>", "<Esc>:m .+1<CR>==gi", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-p>", "<Esc>:m .-2<CR>==gi", { noremap = true, silent = true })
-- For visual mode, ensure the selection stays after moving
vim.api.nvim_set_keymap("v", "<C-p>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-n>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>ps", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
