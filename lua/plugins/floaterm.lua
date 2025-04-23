return {
  "voldikss/vim-floaterm",
  config = function()
    local json = require("lunajson")
    local keymap = vim.keymap

    local settings = {
      shell = "sh",
      file_manager = "none",
    }

    local config_dir = os.getenv("XDG_CONFIG_HOME")
    local file = io.open(config_dir .. "/nvim/env.json", "r")
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
    if settings.file_manager != "none" then
      keymap.set(
        "n",
        "<leader>lf",
        "<CMD>FloatermNew --autoclose=2 --width=0.9 --height=0.9 " .. settings.file_manager .. "<CR>",
        { desc = "Open file manager" }
      )
    end
  end,
}
