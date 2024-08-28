return {
	"christoomey/vim-tmux-navigator",
	lazy = false,
	config = function()
		local keymap = vim.keymap

		keymap.set("n", "<C-m>", "<cmd>TmuxNavigateLeft<CR>", { desc = "window left" })
		keymap.set("n", "<C-n>", "<cmd>TmuxNavigateDown<CR>", { desc = "window down" })
		keymap.set("n", "<C-e>", "<cmd>TmuxNavigateUp<CR>", { desc = "window up" })
		keymap.set("n", "<C-i>", "<cmd>TmuxNavigateRight<CR>", { desc = "window right" })
	end,
}
