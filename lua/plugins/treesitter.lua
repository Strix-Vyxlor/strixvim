return {
	"nvim-treesitter/nvim-treesitter",
	version = "main",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",

	lazy = false,
	config = function()
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local filetype = args.match
				local lang = vim.treesitter.language.get_lang(filetype)
				if vim.treesitter.language.add(lang) then
					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					vim.treesitter.start()
				end
			end,
		})
	end,
}
