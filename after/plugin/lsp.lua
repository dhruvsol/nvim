-- Import lspconfig plugin safely
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	print("Failed to load lspconfig")
	return
end

-- Import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	print("Failed to load cmp_nvim_lsp")
	return
end

-- Import typescript plugin safely
local typescript_setup, typescript = pcall(require, "typescript")
if not typescript_setup then
	print("Failed to load typescript")
	return
end

local keymap = vim.keymap

local on_attach = function(client, bufnr)
	-- Keybind options
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- Set keybinds using Lspsaga or fallback options
	local has_lspsaga, _ = pcall(require, "lspsaga")
	if has_lspsaga then
		keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts)
		keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)
		keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
		keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
		keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
		keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)
		keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
		keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
		keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
	else
		-- Fallback keybindings if Lspsaga is not available
		keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
		keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
		-- Add more fallback keybindings as necessary
	end
	keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts)

	-- Typescript specific keymaps
	if client.name == "tsserver" then
		keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>", opts)
		keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>", opts)
		keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>", opts)
	end
end

-- Enable autocompletion (assign to every lsp server config)
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Change the Diagnostic symbols in the sign column (gutter)
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Configure typescript server with plugin
typescript.setup({
	server = {
		capabilities = capabilities,
		on_attach = on_attach,
		init_options = {
			preferences = {
				disableSuggestions = true,
			},
		},
	},
})
lspconfig["tsserver"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx" },
})

lspconfig["eslint"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig["efm"].setup({
	init_options = { documentFormatting = true },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	settings = {
		rootMarkers = { ".eslintrc.js", ".git/" },
		languages = {
			javascript = {
				{ formatCommand = "eslint --fix --stdin --stdin-filename ${INPUT}", formatStdin = true },
			},
			javascriptreact = {
				{ formatCommand = "eslint --fix --stdin --stdin-filename ${INPUT}", formatStdin = true },
			},
			typescript = {
				{ formatCommand = "eslint --fix --stdin --stdin-filename ${INPUT}", formatStdin = true },
			},
			typescriptreact = {
				{ formatCommand = "eslint --fix --stdin --stdin-filename ${INPUT}", formatStdin = true },
			},
		},
	},
})
-- Makes vim run eslint on save
vim.cmd([[ autocmd BufWritePre *.ts,*.tsx,*.js,*.jsx EslintFixAll ]])

-- Configure CSS server
lspconfig["cssls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- Configure TailwindCSS server
lspconfig["tailwindcss"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- Configure Emmet Language Server
lspconfig["emmet_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
})
