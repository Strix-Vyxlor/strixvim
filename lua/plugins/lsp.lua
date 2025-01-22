return {
	"VonHeikemen/lsp-zero.nvim",
	branch = "v4.x",
	dependencies = {
		-- LSP Support
		{ "neovim/nvim-lspconfig" },

		-- Autocompletion
		{ "hrsh7th/nvim-cmp" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-buffer" },
		{ "hrsh7th/cmp-path" },
		{ "saadparwaiz1/cmp_luasnip" },
		{ "hrsh7th/cmp-nvim-lua" },
		{ "onsails/lspkind.nvim" },
		{ "folke/neodev.nvim" },

		-- Linting
		{ "mfussenegger/nvim-lint" },

		-- Snippets
		{ "L3MON4D3/LuaSnip" },
		{ "rafamadriz/friendly-snippets" },

		-- Esthetic
		{ "folke/trouble.nvim" },
		{ "lukas-reineke/lsp-format.nvim" },

		-- Misc
		{
			"stevearc/conform.nvim",
		},

		-- c, cpp
		--{ "ranjithshegde/ccls.nvim" },

		-- Rust
		{ "simrat39/rust-tools.nvim" },
		{
			"saecki/crates.nvim",
			tag = "v0.4.0",
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				require("crates").setup()
			end,
		},
	},
	config = function()
		local lsp = require("lsp-zero")

		require("neodev").setup({})

		-- lsp.preset("recommended")
		-- lsp.nvim_workspace()
		lsp.ui({
			float_border = "rounded",
			sign_text = {
				error = "✘",
				warn = "▲",
				hint = "⚑",
				info = "»",
			},
		})

		-- Configure Servers
		lsp.setup_servers({
			"lua_ls",
			"rust_analyzer",
			"zls",
			"yamlls",
			"jsonls",
			"pyright",
			"clangd",
			"ts_ls",
		})

		require("lspconfig").nil_ls.setup({
			settings = {
				["nil"] = {
					nix = {
						maxMemoryMB = 7680,
						flake = {
							autoArchive = false,
							autoEvalInputs = false,
						},
					},
				},
			},
		})

		lsp.on_attach(function(client, _)
			require("lsp-format").on_attach(client)
			vim.keymap.set("n", "<space>ma", function()
				vim.lsp.buf.code_action({ apply = true })
			end, bufopts)
		end)
		lsp.setup()

		local cmp = require("cmp")
		local cmp_action = require("lsp-zero").cmp_action()

		vim.api.nvim_create_autocmd("BufRead", {
			group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
			pattern = "Cargo.toml",
			callback = function()
				cmp.setup.buffer({ sources = { { name = "crates" } } })
			end,
		})

		local opts = { silent = true }
		vim.keymap.set("n", "<leader>mc", require("crates").show_popup, opts)

		local luasnip = require("luasnip")

		cmp.setup({
			mapping = {
				["<Tab>"] = cmp_action.luasnip_supertab(),
				["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-q>"] = cmp.mapping.complete(), -- show completion suggestions
				["<C-u>"] = cmp.mapping.abort(), -- close completion window
				["<CR>"] = cmp.mapping.confirm({ select = false }),
			},
			window = {
				completion = {
					winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
					col_offset = -3,
					side_padding = 0,
				},
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- snippets
				{ name = "buffer" }, -- text within current buffer
				{ name = "path" }, -- file system paths
				{ name = "neorg" },
			}),
			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, vim_item)
					local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
					local strings = vim.split(kind.kind, "%s", { trimempty = true })
					kind.kind = " " .. (strings[1] or "") .. " "
					kind.menu = "    (" .. (strings[2] or "") .. ")"

					return kind
				end,
			},
		})

		vim.opt.signcolumn = "yes" -- Disable lsp signals shifting buffer

		vim.diagnostic.config({
			virtual_text = true,
		})

		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				nix = { "alejandra" },
				rust = { "rustfmt" },
				markdown = { "mdformat" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_md = 500,
			},
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				require("conform").format({ bufnr = args.buf })
			end,
		})

		-- lint
		require("lint").linters_by_ft = {
			nix = { "statix" },
		}
		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})

		local util = require("lspconfig.util")
		local server_config = {
			filetypes = { "c", "cpp", "objc", "objcpp", "opencl" },
			root_dir = function(fname)
				return util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")(fname)
					or util.find_git_ancestor(fname)
			end,
			init_options = {
				cache = {
					directory = vim.env.XDG_CACHE_HOME .. "/ccls/",
					-- or vim.fs.normalize "~/.cache/ccls" -- if on nvim 0.8 or higher
				},
			},
			--on_attach = require("my.attach").func,
			--capabilities = my_caps_table_or_func
		}
		--require("ccls").setup({ lsp = { lspconfig = server_config } })
	end,
}
