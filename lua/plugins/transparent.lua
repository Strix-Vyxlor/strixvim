return {
	"xiyaowong/transparent.nvim",
	lazy = false,
	config = function()
		local keymap = vim.keymap

		keymap.set("n", "<leader>tt", "<cmd>TransparentToggle<CR>", { desc = "toggle transparency" })
	end,
}
