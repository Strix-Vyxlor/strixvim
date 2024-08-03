vim.g.mapleader = " "

local keymap = vim.keymap

-- window management --
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- tabs --
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go te previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- lazy management --
keymap.set("n", "<leader>ui", "<cmd>Lazy install<CR>",  { desc = "Install new plugins" })
keymap.set("n", "<leader>uu", "<cmd>Lazy update<CR>", { desc = "Update plugins" })
keymap.set("n", "<leader>us", "<cmd>Lazy sync<CR>", { desc = "Sync plugins" })
keymap.set("n", "<leader>um", "<cmd>Lazy<CR>", { desc = "Open Lazy menu" })

-- quiting --
keymap.set("n", "<leader>qq", "<cmd>q<CR>", { desc = "quit" })
keymap.set("n", "<leader>qf", "<cmd>q!<CR>", { desc = "force quit" })
keymap.set("n", "<leader>qa", "<cmd>qa<CR>", { desc = "quit all panes" })
keymap.set("n", "<leader>qs", "<cmd>wq<CR>", { desc = "save and quit" })

-- save --
keymap.set("n", "<leader>ww", "<cmd>w<CR>", { desc = "Save current file" })
keymap.set("n", "<leader>wa", "<cmd>wa<CR>", { desc = "Save all files" })

