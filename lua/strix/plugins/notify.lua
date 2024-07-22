return {
  "rcarriga/nvim-notify",
  config = function()
    local notify = require("notify")

    notify.setup({
      render = "wrapped-compact",
      timeout = 2500,
    })
  end
}
