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
				["core.keybinds"] = {
					config = {
						neorg_leader = "<C-n>",
					},
				},
			},
		})
	end,
}
