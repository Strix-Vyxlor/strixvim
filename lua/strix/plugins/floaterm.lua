return {
  "voldikss/vim-floaterm",
  config = function()
    local keymap = vim.keymap

    keymap.set("n", "<leader>lt", "<CMD>FloatermNew --autoclose=2 --width=0.9 --height=0.9 zsh<CR>", { desc = "Open terminal" })
  end
}
