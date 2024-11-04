return {
	"RRethy/base16-nvim",
	name = "base16",
	priority = 1000,
	config = function()
		require("base16-colorscheme").with_config({
			telescope = true,
			indentblankline = true,
			notify = true,
			ts_rainbow = true,
			cmp = true,
			illuminate = true,
			dapui = true,
		})

		require("base16-colorscheme").setup({
			base00 = "#271815",
			base01 = "#1e100d",
			base02 = "#5a0e09",
			base03 = "#473532",
			base04 = "#bdaba8",
			base05 = "#ffedea",
			base06 = "#e0bfba",
			base07 = "#bf5f00",
			base08 = "#b51e13",
			base09 = "#cc4a00",
			base0A = "#f0af1f",
			base0B = "#f8c947",
			base0C = "#c1b53d",
			base0D = "#fb852c",
			base0E = "#731a16",
			base0F = "#643130",
		})
	end,
}
