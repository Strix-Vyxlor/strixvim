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

		local keymap = vim.keymap

		keymap.set("n", "<leader>nn", "<Plug>(neorg.dirman.new-note)")
	end,
}
