return {
	"voldikss/vim-floaterm",
	config = function()
		local keymap = vim.keymap

		keymap.set(
			"n",
			"<leader>lt",
			"<CMD>FloatermNew --autoclose=2 --width=0.9 --height=0.9 nu<CR>",
			{ desc = "Open terminal" }
		)
		keymap.set(
			"n",
			"<leader>lf",
			"<CMD>FloatermNew --autoclose=2 --width=0.9 --height=0.9 spf<CR>",
			{ desc = "Open superfile" }
		)
	end,
}
