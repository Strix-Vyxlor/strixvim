return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {},
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
		config = function()
			require("render-markdown").setup({})

			local keymap = vim.keymap

			keymap.set("n", "<leader>mt", "<cmd>RenderMarkdown toggle<CR>", { desc = "toggle markdown" })
		end,
	},
}
