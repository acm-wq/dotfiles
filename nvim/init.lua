-- Basic settings
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.textwidth = 80
vim.opt.wrap = false 

vim.opt.colorcolumn = '80'

-- Lazy.nvim setup
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    { "nvim-tree/nvim-web-devicons", opts = {} },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = { 
            "lua",
            "python",
            "ruby",
            "go",
            "javascript",
            "typescript",
            "lua",
            "html",
            "css",
            "json",
            "bash" 
          }, -- Language
          highlight = { enable = true },
          indent = { enable = true },
        })
      end,
    },
    {
      "nvim-tree/nvim-tree.lua",
      version = "*",
      lazy = false,
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("nvim-tree").setup({
          on_attach = function(bufnr)
            local api = require("nvim-tree.api")
            -- Default mappings
            api.config.mappings.default_on_attach(bufnr)
            -- Custom <CR> mapping: close nvim-tree only when opening a file
            vim.keymap.set('n', '<CR>', function()
              local node = api.tree.get_node_under_cursor()
              if node.type == "file" then
                api.node.open.edit()
                api.tree.close()
              else
                api.node.open.edit() -- Expand folder or navigate
              end
            end, { buffer = bufnr, noremap = true, silent = true, nowait = true })
          end,
          view = {
            width = 30,
            side = "left",
          },
        })
      end,
    },
    -- Telescope
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.8",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        -- Basic Telescope configuration
        require("telescope").setup({
          defaults = {
            mappings = {
              i = {
                ["<C-j>"] = require("telescope.actions").move_selection_next,
                ["<C-k>"] = require("telescope.actions").move_selection_previous,
              },
            },
          },
        })
      end,
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "catppuccin" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})


-- Customization setup
vim.cmd.colorscheme "catppuccin-mocha"

-- Settings
vim.keymap.set("n", "<leader>t", "<cmd>Telescope find_files<CR>", { desc = "Open Telescope find files" })
vim.keymap.set("n", "<leader>n", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
-- Enable Telescope multi-selection for opening multiple files
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = require("telescope.actions").move_selection_next,
        ["<C-k>"] = require("telescope.actions").move_selection_previous,
        ["<Tab>"] = require("telescope.actions").toggle_selection + require("telescope.actions").move_selection_next,
        ["<S-Tab>"] = require("telescope.actions").toggle_selection + require("telescope.actions").move_selection_previous,
        ["<CR>"] = require("telescope.actions").select_default, -- Open selected files
      },
    },
  },
})

-- Buffer navigation keybindings
vim.keymap.set("n", "<leader>l", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>h", ":bprevious<CR>", { desc = "Previous buffer" }) -- Optional: for symmetry

-- Optional: Telescope buffer picker for easier buffer switching
vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<CR>", { desc = "List open buffers" })
