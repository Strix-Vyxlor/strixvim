return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "saghen/blink.cmp", build = "cargo build --release" },

		{ "onsails/lspkind.nvim" },
		{ "nvim-tree/nvim-web-devicons" },

		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
		},

		{ "mfussenegger/nvim-lint" },

		{ "folke/trouble.nvim" },

		{ "lukas-reineke/lsp-format.nvim" },
		{ "stevearc/conform.nvim" },

		{
			"saecki/crates.nvim",
			event = { "BufRead Cargo.toml" },
		},
	},

	opts = {
		servers = {
			lua_ls = {},
			rust_analyzer = {},
			zls = {},
			yamlls = {},
			jsonls = {},
			pyright = {},
			clangd = {},
			ts_ls = {},
			jdtls = {},
			gdscript = {},
			gdshader_lsp = {},
			nil_ls = {
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
			},
		},
		linters = {
			nix = { "statix" },
			gdscript = { "gdlint" },
		},
		formatters = {
			lua = { "stylua" },
			nix = { "alejandra" },
			rust = { "rustfmt" },
			python = { "isort", "black" },
			java = { "google-java-format" },
			kotlin = { "ktfmt" },
			gdscript = { "gdformat" },
		},
		sources = {
			default = { "lazydev", "lsp", "path", "buffer" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
			},
		},
	},
	config = function(_, opts)
		local lspconfig = require("lspconfig")
		local blink = require("blink.cmp")
		for server, config in pairs(opts.servers) do
			-- passing config.capabilities to blink.cmp merges with the capabilities in your
			-- `opts[server].capabilities, if you've defined it
			config.capabilities = blink.get_lsp_capabilities(config.capabilities)
			lspconfig[server].setup(config)
		end

		-- SECTION: blink
		local theme_colors = require("base16-colorscheme").colors
		local set_hl = vim.api.nvim_set_hl

		set_hl(0, "BlinkCmpMenu", { bg = theme_colors.base01, fg = theme_colors.base06 })
		set_hl(0, "BlinkCmpMenuSelection", { bg = theme_colors.base02, fg = theme_colors.base06 })

		blink.setup({
			keymap = {
				preset = "none",
				["<Tab>"] = { "select_next", "fallback" },
				["<S-Tab>"] = { "select_prev", "fallback" },
				["<C-q>"] = { "show_and_insert", "fallback" },
				["<C-e>"] = { "cancel", "fallback" },
				["<CR>"] = { "accept", "fallback" },
			},
			completion = {
				documentation = { auto_show = true },
				list = { selection = { preselect = true } },
				menu = {
					draw = {
						components = {
							kind_icon = {
								text = function(ctx)
									local icon = ctx.kind_icon
									if vim.tbl_contains({ "Path" }, ctx.source_name) then
										local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
										if dev_icon then
											icon = dev_icon
										end
									else
										icon = require("lspkind").symbolic(ctx.kind, {
											mode = "symbol",
										})
									end

									return icon .. ctx.icon_gap
								end,

								-- Optionally, use the highlight groups from nvim-web-devicons
								-- You can also add the same function for `kind.highlight` if you want to
								-- keep the highlight groups in sync with the icons.
								highlight = function(ctx)
									local hl = ctx.kind_hl
									if vim.tbl_contains({ "Path" }, ctx.source_name) then
										local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
										if dev_icon then
											hl = dev_hl
										end
									end
									return hl
								end,
							},
						},
						columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
					},
				},
			},
		})

		-- SECTION: linting
		local lint = require("lint")
		lint.linters_by_ft = opts.linters
		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})

		-- SECTION: formatting
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = opts.formatters,
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_md = 500,
			},
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				conform.format({ bufnr = args.buf })
			end,
		})
	end,
}

-- return {
-- 	"VonHeikemen/lsp-zero.nvim",
-- 	branch = "v4.x",
-- 	dependencies = {
-- 		-- LSP Support
-- 		{ "neovim/nvim-lspconfig" },
--
-- 		-- Autocompletion
-- 		{ "hrsh7th/nvim-cmp" },
-- 		{ "hrsh7th/cmp-nvim-lsp" },
-- 		{ "hrsh7th/cmp-buffer" },
-- 		{ "hrsh7th/cmp-path" },
-- 		{ "saadparwaiz1/cmp_luasnip" },
-- 		{ "hrsh7th/cmp-nvim-lua" },
-- 		{ "onsails/lspkind.nvim" },
-- 		{ "folke/neodev.nvim" },
--
-- 		-- Linting
-- 		{ "mfussenegger/nvim-lint" },
--
-- 		-- Snippets
-- 		{ "L3MON4D3/LuaSnip" },
-- 		{ "rafamadriz/friendly-snippets" },
--
-- 		-- Esthetic
-- 		{ "folke/trouble.nvim" },
-- 		{ "lukas-reineke/lsp-format.nvim" },
--
-- 		-- Misc
-- 		{
-- 			"stevearc/conform.nvim",
-- 		},
--
-- 		-- Rust
-- 		{ "simrat39/rust-tools.nvim" },
-- 		{
-- 			"saecki/crates.nvim",
-- 			tag = "stable",
-- 			dependencies = { "nvim-lua/plenary.nvim" },
-- 			config = function()
-- 				require("crates").setup({
-- 					completion = {
-- 						cmp = {
-- 							enabled = true,
-- 						},
-- 					},
-- 				})
-- 			end,
-- 		},
--
-- 		-- Java
-- 		{
-- 			"nvim-java/nvim-java",
-- 			dependencies = {
-- 				"nvim-java/lua-async-await",
-- 				"nvim-java/nvim-java-refactor",
-- 				"nvim-java/nvim-java-core",
-- 				"nvim-java/nvim-java-test",
-- 				"nvim-java/nvim-java-dap",
-- 				"MunifTanjim/nui.nvim",
-- 				"neovim/nvim-lspconfig",
-- 				"mfussenegger/nvim-dap",
-- 				{
-- 					"JavaHello/spring-boot.nvim",
-- 					commit = "218c0c26c14d99feca778e4d13f5ec3e8b1b60f0",
-- 				},
-- 			},
-- 		},
-- 	},
-- 	config = function()
-- 		local lsp = require("lsp-zero")
--
-- 		require("neodev").setup({})
-- 		require("java").setup({
-- 			jdk = { auto_install = false },
-- 		})
--
-- 		lsp.ui({
-- 			float_border = "rounded",
-- 			sign_text = {
-- 				error = "✘",
-- 				warn = "▲",
-- 				hint = "⚑",
-- 				info = "»",
-- 			},
-- 		})
--
-- 		-- Configure Servers
-- 		lsp.setup_servers({
-- 			"lua_ls",
-- 			"rust_analyzer",
-- 			"zls",
-- 			"yamlls",
-- 			"jsonls",
-- 			"pyright",
-- 			"clangd",
-- 			"ts_ls",
-- 			"jdtls",
-- 		})
--
-- 		require("lspconfig").nil_ls.setup({
-- 			settings = {
-- 				["nil"] = {
-- 					nix = {
-- 						maxMemoryMB = 7680,
-- 						flake = {
-- 							autoArchive = false,
-- 							autoEvalInputs = false,
-- 						},
-- 					},
-- 				},
-- 			},
-- 		})
--
-- 		lsp.on_attach(function(client, _)
-- 			require("lsp-format").on_attach(client)
-- 			vim.keymap.set("n", "<space>ma", function()
-- 				vim.lsp.buf.code_action({ apply = true })
-- 			end, bufopts)
-- 		end)
-- 		lsp.setup()
--
-- 		local cmp = require("cmp")
-- 		local cmp_action = require("lsp-zero").cmp_action()
--
-- 		vim.api.nvim_create_autocmd("BufRead", {
-- 			group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
-- 			pattern = "Cargo.toml",
-- 			callback = function()
-- 				cmp.setup.buffer({ sources = { { name = "crates" } } })
-- 			end,
-- 		})
--
-- 		local opts = { silent = true }
-- 		vim.keymap.set("n", "<leader>mc", require("crates").show_popup, opts)
--
-- 		local luasnip = require("luasnip")
--
-- 		cmp.setup({
-- 			mapping = {
-- 				["<Tab>"] = cmp_action.luasnip_supertab(),
-- 				["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
-- 				["<C-b>"] = cmp.mapping.scroll_docs(-4),
-- 				["<C-f>"] = cmp.mapping.scroll_docs(4),
-- 				["<C-q>"] = cmp.mapping.complete(), -- show completion suggestions
-- 				["<C-e>"] = cmp.mapping.abort(), -- close completion window
-- 				["<CR>"] = cmp.mapping.confirm({ select = true }),
-- 			},
-- 			window = {
-- 				completion = {
-- 					winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
-- 					col_offset = -3,
-- 					side_padding = 0,
-- 				},
-- 			},
-- 			sources = cmp.config.sources({
-- 				{ name = "nvim_lsp" },
-- 				{ name = "luasnip" }, -- snippets
-- 				{ name = "buffer" }, -- text within current buffer
-- 				{ name = "path" }, -- file system paths
-- 				{ name = "neorg" },
-- 				{ name = "crates" },
-- 			}),
-- 			formatting = {
-- 				fields = { "kind", "abbr", "menu" },
-- 				format = function(entry, vim_item)
-- 					local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
-- 					local strings = vim.split(kind.kind, "%s", { trimempty = true })
-- 					kind.kind = " " .. (strings[1] or "") .. " "
-- 					kind.menu = "    (" .. (strings[2] or "") .. ")"
--
-- 					return kind
-- 				end,
-- 			},
-- 		})
--
-- 		vim.opt.signcolumn = "yes" -- Disable lsp signals shifting buffer
--
-- 		vim.diagnostic.config({
-- 			virtual_text = true,
-- 		})
--
-- 		require("conform").setup({
-- 			formatters_by_ft = {
-- 				lua = { "stylua" },
-- 				nix = { "alejandra" },
-- 				rust = { "rustfmt" },
-- 			},
-- 			format_on_save = {
-- 				lsp_fallback = true,
-- 				async = false,
-- 				timeout_md = 500,
-- 			},
-- 		})
--
-- 		vim.api.nvim_create_autocmd("BufWritePre", {
-- 			pattern = "*",
-- 			callback = function(args)
-- 				require("conform").format({ bufnr = args.buf })
-- 			end,
-- 		})
--
-- 		-- lint
-- 		require("lint").linters_by_ft = {
-- 			nix = { "statix" },
-- 		}
-- 		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
-- 			callback = function()
-- 				require("lint").try_lint()
-- 			end,
-- 		})
-- 	end,
-- }
