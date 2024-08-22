local cmp_status, cmp = pcall(require, "cmp")
if not cmp_status then
	return
end

local luasnip_status, luasnip = pcall(require, "luasnip")
if not luasnip_status then
	return
end

local lspkind_status, lspkind = pcall(require, "lspkind")
if not lspkind_status then
	return
end

-- Lazy load LuaSnip with VSCode style snippets for React and other languages
require("luasnip/loaders/from_vscode").lazy_load()

-- Set Neovim's completion options
vim.o.completeopt = "menu,menuone,noselect"

cmp.setup({
	snippet = {
		-- Setup LuaSnip for snippet expansion
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-k>"] = cmp.mapping.select_prev_item(), -- Navigate to previous suggestion
		["<C-j>"] = cmp.mapping.select_next_item(), -- Navigate to next suggestion
		["<C-b>"] = cmp.mapping.scroll_docs(-4), -- Scroll documentation up
		["<C-f>"] = cmp.mapping.scroll_docs(4), -- Scroll documentation down
		["<C-Space>"] = cmp.mapping.complete(), -- Trigger completion suggestions
		["<C-e>"] = cmp.mapping.abort(), -- Close completion window
		["<CR>"] = cmp.mapping.confirm({ select = false }), -- Confirm selection
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" }, -- LSP suggestions
		{ name = "luasnip" }, -- Snippet suggestions
		{ name = "buffer" }, -- Suggestions from current buffer
		{ name = "path" }, -- Filesystem path suggestions
	}),
	formatting = {
		format = lspkind.cmp_format({
			maxwidth = 50, -- Max width of completion items
			ellipsis_char = "...", -- Character to show for truncated text
		}),
	},
})
