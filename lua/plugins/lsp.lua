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

		{ "onsails/lspkind.nvim" },
		{ "nvim-tree/nvim-web-devicons" },

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
			--clangd = {},
			ccls = {
				init_options = {
					cache = {
						directory = ".ccls-cache",
					},
				},
			},
			ts_ls = {},
			jdtls = {},
			gdscript = {},
			gdshader_lsp = {},
			vala_ls = {},
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
			python = { "pylint" },
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
		sign_text = {
			error = "✘",
			warn = "▲",
			hint = "⚑",
			info = "»",
		},
	},
	config = function(_, opts)
		local blink = require("blink.cmp")
		for server, config in pairs(opts.servers) do
			config.capabilities = blink.get_lsp_capabilities(config.capabilities)
			vim.lsp.enable(server)
			if config then
				vim.lsp.config(server, config)
			end
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
			signature = { enabled = true },
			completion = {
				documentation = { auto_show = true },
				list = { selection = { preselect = true, auto_insert = false } },
				ghost_text = { enabled = true },
				menu = {
					auto_show = true,
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
					},
				},
			},
			cmdline = {
				keymap = {
					preset = "none",
					["<Tab>"] = { "show", "select_next", "fallback" },
					["<S-Tab>"] = { "select_prev", "fallback" },
					["<C-q>"] = { "show_and_insert", "fallback" },
					["<C-e>"] = { "cancel", "fallback" },
					["<CR>"] = { "accept", "fallback" },
				},
				completion = {
					ghost_text = { enabled = true },
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

		-- python linking
		require("lint").linters.pylint.cmd = "python"
		require("lint").linters.pylint.args = { "-m", "pylint", "-f", "json" }

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

		-- SECTION: icons
		require("trouble").setup({})
		local ds = vim.diagnostic.severity
		local levels = {
			[ds.ERROR] = "error",
			[ds.WARN] = "warn",
			[ds.INFO] = "info",
			[ds.HINT] = "hint",
		}

		local text = {}

		for i, l in pairs(levels) do
			if type(opts.sign_text[l]) == "string" then
				text[i] = opts.sign_text[l]
			end
		end

		vim.diagnostic.config({
			signs = { text = text },
			virtual_text = {
				prefix = "•",
			},
			severity_sort = true,
			float = {
				source = "always",
			},
		})
	end,
}
