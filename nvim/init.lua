local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
local uv = vim.uv or vim.loop

-- set tab size to 2
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Yank to system clipboard
vim.cmd[[set clipboard=unnamedplus]]


-- Auto-install lazy.nvim if not present
if not uv.fs_stat(lazypath) then
  print('Installing lazy.nvim....')
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
  print('Done.')
end
 

vim.opt.rtp:prepend(lazypath)

-- Install plugins if not present
require('lazy').setup({
  {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
  {'neovim/nvim-lspconfig'},
  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/nvim-cmp'},
  {'hrsh7th/cmp-buffer'},
  {'L3MON4D3/LuaSnip'},
  {'NvChad/nvterm',
  config = function ()
    require("nvterm").setup()
  end,
  },
  {"nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function () 
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = { "c", "lua", "cpp", "haskell", "python", "glsl" },
          sync_install = false,
          highlight = { enable = true, additional_vim_regex_highlighting = false },
          indent = { enable = true },  
        })
    end
 },
 { 'dasupradyumna/midnight.nvim', lazy = false, priority = 1000 },
 {'m4xshen/autoclose.nvim'},
 {
  "lervag/vimtex",
  lazy = false,     -- we don't want to lazy load VimTeX
  init = function()
    -- VimTeX configuration goes here
    vim.g.vimtex_view_method = "zathura"
  end
}
})

-- Set autoclose brackets
require("autoclose").setup({})

-- Set color scheme
vim.cmd[[colorscheme midnight]]

local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr,
                            preserve_mappings = false})
end)

require('lspconfig').hls.setup({})
require('lspconfig').clangd.setup({})
require('lspconfig').pyright.setup({})
require('lspconfig').glsl_analyzer.setup({})


local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
local cmp_format = require('lsp-zero').cmp_format({details = true})

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
    {name = 'buffer'},
  },
  --- (Optional) Show source name in completion menu
  formatting = cmp_format,

  mapping = cmp.mapping.preset.insert({
    -- confirm completion
    ['<Enter>'] = cmp.mapping.confirm({select = false}),

    ['<Tab>'] = cmp_action.tab_complete(),
    ['<S-Tab>'] = cmp_action.select_prev_or_fallback(),
    }),

  preselect = 'item',
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
}) 

-- Custom keybindings
vim.g.mapleader = " "

vim.keymap.set("n", "<C-s>", ":w<CR>")

vim.keymap.set("n", "<Tab>", ":tabn<CR>")
vim.keymap.set("n", "<S-Tab>", ":tabp<CR>")
vim.keymap.set("n", "<C-n>", ":tabe ")

vim.keymap.set({"n", "t"}, "<A-i>", function () require("nvterm.terminal").toggle('float') end)
vim.keymap.set({"n", "t"}, "<A-h>", function () require("nvterm.terminal").toggle('horizontal') end)
