return {
	"RRethy/base16-nvim",
	name = "base16",
	priority = 1000,
	config = function()
		local colorscheme = require("base16-colorscheme")
		local json = require("lunajson")

		local theme = {
			base00 = "#1e1e2e",
			base01 = "#181825",
			base02 = "#313244",
			base03 = "#45475a",
			base04 = "#585b70",
			base05 = "#cdd6f4",
			base06 = "#f5e0dc",
			base07 = "#b4befe",
			base08 = "#f38ba8",
			base09 = "#fab387",
			base0A = "#f9e2af",
			base0B = "#a6e3a1",
			base0C = "#94e2d5",
			base0D = "#89b4fa",
			base0E = "#cba6f7",
			base0F = "#f2cdcd",
		}

		local config_dir = os.getenv("XDG_CONFIG_HOME")
    if config_dir == nil then
      config_dir = "~/.config"
    end
		local file = io.open(config_dir .. "/stylix/palette.json", "r")
		if file then
			local content = file:read("*a")
			io.close(file)
			local data = json.decode(content)

			theme = {
				base00 = "#" .. data.base00,
				base01 = "#" .. data.base01,
				base02 = "#" .. data.base02,
				base03 = "#" .. data.base03,
				base04 = "#" .. data.base04,
				base05 = "#" .. data.base05,
				base06 = "#" .. data.base06,
				base07 = "#" .. data.base07,
				base08 = "#" .. data.base08,
				base09 = "#" .. data.base09,
				base0A = "#" .. data.base0A,
				base0B = "#" .. data.base0B,
				base0C = "#" .. data.base0C,
				base0D = "#" .. data.base0D,
				base0E = "#" .. data.base0E,
				base0F = "#" .. data.base0F,
			}
		end

		colorscheme.with_config({
			telescope = true,
			indentblankline = true,
			notify = true,
			ts_rainbow = true,
			cmp = true,
			illuminate = true,
			dapui = true,
		})

		colorscheme.setup(theme)
	end,
}
