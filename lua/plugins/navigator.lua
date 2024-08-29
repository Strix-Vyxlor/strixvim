return {
	"christoomey/vim-tmux-navigator",
	lazy = false,
	config = function()
		local keymap = vim.keymap

		keymap.set("n", "<C-Left>", "<cmd>TmuxNavigateLeft<CR>", { desc = "window left" })
		keymap.set("n", "<C-Down>", "<cmd>TmuxNavigateDown<CR>", { desc = "window down" })
		keymap.set("n", "<C-Up>", "<cmd>TmuxNavigateUp<CR>", { desc = "window up" })
		keymap.set("n", "<C-Right>", "<cmd>TmuxNavigateRight<CR>", { desc = "window right" })
	end,
}
