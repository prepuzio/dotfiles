local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		lazypath
	})
end

vim.opt.rtp:prepend(lazypath)

vim.opt.number = true
vim.opt.relativenumber = true

require("lazy").setup({
	{ 
		"folke/zen-mode.nvim",
		keys = {
			{ "<leader>z", "<cmd>ZenMode<CR>" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
	},
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			require("mason").setup()

			require("mason-lspconfig").setup({
				ensure_installed = {
					"clangd",
					"gopls",
					"pyright",
					"lua_ls",
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
	},
	{
		"simrat39/symbols-outline.nvim",
		cmd = "SymbolsOutline",
		keys = {
			{ "<leader>o", "<cmd>SymbolsOutline<CR>", desc = "Symbols Outline" },
		},
		config = true,
	},
	{ 'github/copilot.vim' },
	{
		"jakobkhansen/journal.nvim",
		config = function()
			require("journal").setup()
		end,
	},
	{
		'nvim-orgmode/orgmode',
		event = 'VeryLazy',
		config = function()
			-- Setup orgmode
			require('orgmode').setup({
				org_agenda_files = '~/orgfiles/**/*',
				org_default_notes_file = '~/orgfiles/refile.org',
			})
		end,
	},
	{ "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = ...},
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{
		"junegunn/fzf",
		build = "./install --bin",
		lazy = false,
	},
	{
		"easymotion/vim-easymotion",
		init = function()
			-- optional but sane defaults
			vim.g.EasyMotion_do_mapping = 0
			vim.g.EasyMotion_smartcase = 1
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				markdown = { "prettier" },
			},
		},
	},
	{
		"junegunn/fzf.vim",
		keys = {
			{ ",f", "<cmd>Files<CR>",   silent = true },
			{ ",b", "<cmd>Buffers<CR>", silent = true },
			{ ",/", "<cmd>BLines<CR>",  silent = true },
			{ ",*", "<cmd>Lines<CR>",   silent = true },
			{ ",g", "<cmd>Rg<CR>",      silent = true },
		},
		lazy = false,

	},
	{
		"sjl/badwolf",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd("colorscheme badwolf")
		end,
	},
	{ "mbbill/undotree" },
	{ "akinsho/git-conflict.nvim" },
	{ "akinsho/toggleterm.nvim", version = "*", config = function()
		require("toggleterm").setup{
			size = 15,
			open_mapping = [[<c-\>]],
			direction = 'horizontal',
			shade_terminals = true,
			persist_size = true,
		}
	end },
	{ "nvim-neo-tree/neo-tree.nvim", branch = "v3.x", dependencies = { 
		"nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim", }, config = function()
			require("neo-tree").setup({
				window = { 
					width = 30, 
					position = "left",
					mappings = {
						["<tab>"] = "toggle_node",  
					},
				},
			})
		end
	}
})

-- lsp show
vim.api.nvim_set_keymap('n', '<leader>o', ':SymbolsOutline<CR>', { noremap = true, silent = true })

-- Easymotion, fix for conflict between lsp diagnostic virtual text and easymotion overwin
vim.api.nvim_create_autocmd("User", {
	pattern = "EasyMotionPromptBegin",
	callback = function()
		vim.diagnostic.disable()
	end,
})
vim.api.nvim_create_autocmd("User", {
	pattern = "EasyMotionPromptEnd",
	callback = function()
		vim.diagnostic.enable()
	end,
})

-- Easymotion, operator pending compatible mappings
vim.keymap.set({ "n", "x", "o" }, "\\f", "<Plug>(easymotion-f)")
vim.keymap.set({ "n", "x", "o" }, "\\F", "<Plug>(easymotion-F)")
vim.keymap.set({ "n", "x", "o" }, "\\t", "<Plug>(easymotion-t)")
vim.keymap.set({ "n", "x", "o" }, "\\T", "<Plug>(easymotion-T)")
vim.keymap.set({ "n", "x", "o" }, "\\w", "<Plug>(easymotion-w)")
vim.keymap.set({ "n", "x", "o" }, "\\e", "<Plug>(easymotion-e)")
vim.keymap.set({ "n", "x", "o" }, "\\W", "<Plug>(easymotion-W)")
vim.keymap.set({ "n", "x", "o" }, "\\E", "<Plug>(easymotion-E)")
vim.keymap.set({ "n", "x", "o" }, "\\b", "<Plug>(easymotion-b)")
vim.keymap.set({ "n", "x", "o" }, "\\B", "<Plug>(easymotion-B)")
vim.keymap.set({ "n", "x", "o" }, "\\l", "<Plug>(easymotion-line)")
vim.keymap.set({ "n", "x", "o" }, "\\j", "<Plug>(easymotion-j)")
vim.keymap.set({ "n", "x", "o" }, "\\k", "<Plug>(easymotion-k)")

vim.keymap.set({"n"}, ",w", "<Plug>(easymotion-overwin-w)")

-- conform
vim.keymap.set("n", "<leader><leader>c", function()
	require("conform").format({ async = true })
end)

-- UndoTree
vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<cr>', { silent = true })

-- toggle term
vim.keymap.set('n', '<C-t>', '<cmd>ToggleTerm<cr>')
vim.keymap.set('t', '<C-t>', '<C-\\><C-n><cmd>ToggleTerm<cr>')

-- term controls
vim.api.nvim_set_keymap('t', '<C-w>w', [[<C-\><C-n><C-w>w]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-w>h', [[<C-\><C-n><C-w>h]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-w>j', [[<C-\><C-n><C-w>j]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-w>k', [[<C-\><C-n><C-w>k]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-w>l', [[<C-\><C-n><C-w>l]], { noremap = true, silent = true })

-- Neo-tree
vim.keymap.set('n', ',,', ':Neotree toggle <CR>', { silent = true })
