vim.g.mapleader = " "
vim.g.maplocalleader = " "

local o = vim.opt
o.number = true
o.relativenumber = true
o.cursorline = true
o.termguicolors = true
o.signcolumn = "yes"
o.scrolloff = 8
o.mouse = "a"
o.clipboard = "unnamedplus"
o.ignorecase = true
o.smartcase = true
o.undofile = true
o.updatetime = 250
o.splitright = true
o.splitbelow = true
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.showmode = false
o.fillchars = { eob = " " }

require("solitude").setup()

-- Interfaccia ---------------------------------------------------------------
require("mini.icons").setup()
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.comment").setup()
require("mini.indentscope").setup({ symbol = "│", draw = { animation = function() return 0 end } })

require("lualine").setup({
  options = {
    theme = "auto",
    component_separators = "",
    section_separators = "",
    globalstatus = true,
  },
})

require("gitsigns").setup()
require("which-key").setup({ preset = "modern" })
require("oil").setup({ view_options = { show_hidden = true } })

-- Ricerca -------------------------------------------------------------------
local telescope = require("telescope")
telescope.setup({
  defaults = {
    borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    prompt_prefix = "> ",
    selection_caret = "> ",
  },
})
local builtin = require("telescope.builtin")

-- Treesitter ----------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

-- Completamento -------------------------------------------------------------
require("blink.cmp").setup({
  keymap = { preset = "default" },
  completion = { documentation = { auto_show = true } },
  sources = { default = { "lsp", "path", "buffer" } },
})

-- LSP -----------------------------------------------------------------------
vim.lsp.config("lua_ls", {
  settings = { Lua = { diagnostics = { globals = { "vim" } } } },
})
vim.lsp.enable({ "nixd", "lua_ls", "bashls" })

vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = { border = "single" },
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local map = function(keys, fn, desc)
      vim.keymap.set("n", keys, fn, { buffer = args.buf, desc = desc })
    end
    map("gd", vim.lsp.buf.definition, "Vai alla definizione")
    map("gr", vim.lsp.buf.references, "Riferimenti")
    map("K", vim.lsp.buf.hover, "Documentazione")
    map("<leader>rn", vim.lsp.buf.rename, "Rinomina")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("<leader>f", function() vim.lsp.buf.format({ async = true }) end, "Formatta")
  end,
})

-- Mappature -----------------------------------------------------------------
local map = vim.keymap.set
map("n", "<leader>ff", builtin.find_files, { desc = "Trova file" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Cerca nel testo" })
map("n", "<leader>fb", builtin.buffers, { desc = "Buffer" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Help" })
map("n", "-", "<cmd>Oil<cr>", { desc = "File manager" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>")
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Diagnostica" })
