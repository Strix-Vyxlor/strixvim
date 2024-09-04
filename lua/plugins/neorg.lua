return {
	"nvim-neorg/neorg",
	lazy = false,
	version = "*",
	config = function()
		require("neorg").setup({
			load = {
				["core.defaults"] = {},
				["core.concealer"] = {},
				["core.dirman"] = {
					config = {
						workspaces = {
							notes = "~/Documents/notes",
							school = "~/Documents/school/norg",
						},
					},
				},
				["core.completion"] = {
					config = {
						engine = "nvim-cmp",
					},
				},
				["core.export"] = {},
			},
		})

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
			pattern = { "*.norg" },
			command = "set conceallevel=3",
		})

		local keymap = vim.keymap

		keymap.set("n", "<leader>nn", "<Plug>(neorg.dirman.new-note)")
		keymap.set("n", "<leader>ni", "<Cmd>Neorg index<CR>")
	end,
}
