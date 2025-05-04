return {
	"voldikss/vim-floaterm",
	config = function()
		local json = require("lunajson")
		local keymap = vim.keymap

		local settings = {
			shell = "sh",
			fileManager = "none",
		}

		local config_dir = os.getenv("XDG_CONFIG_HOME")
		if config_dir == nil then
			config_dir = "~/.config"
		end
		local file = io.open(config_dir .. "/svim/env.json", "r")
		if file then
			local content = file:read("*a")
			io.close(file)
			settings = json.decode(content)
		end

		keymap.set(
			"n",
			"<leader>lt",
			"<CMD>FloatermNew --autoclose=2 --width=0.9 --height=0.9 " .. settings.shell .. "<CR>",
			{ desc = "Open terminal" }
		)
		if settings.fileManager ~= "none" then
			keymap.set(
				"n",
				"<leader>lf",
				"<CMD>FloatermNew --autoclose=2 --width=0.9 --height=0.9 " .. settings.file_manager .. "<CR>",
				{ desc = "Open file manager" }
			)
		end
	end,
}
