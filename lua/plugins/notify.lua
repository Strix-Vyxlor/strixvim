return {
  "rcarriga/nvim-notify",
  config = function()
    local notify = require("notify")

    vim.notify = notify

    notify.setup({
      render = "default",
      stages = "slide",
      timeout = 2500,
    })
  end
}
