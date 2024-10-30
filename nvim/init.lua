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
	{'micangl/cmp-vimtex'},
  {'hrsh7th/cmp-buffer'},
  {'L3MON4D3/LuaSnip',
	 dependencies = { "rafamadriz/friendly-snippets" },
  },
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
    vim.g.vimtex_view_method = "general"
    vim.g.vimtex_view_general_viewer = "okular"
    vim.g.vimtex_view_general_options = "--unique file:@pdf\\#src:@line@tex"
  end
  
 },
 {
	"L3MON4D3/LuaSnip",
	-- follow latest release.
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	build = "make install_jsregexp"
 },
 { 'saadparwaiz1/cmp_luasnip' },
 { "rafamadriz/friendly-snippets" },
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

-- Setup LSPs
require('lspconfig').hls.setup({})
require('lspconfig').clangd.setup({})
require('lspconfig').pyright.setup({})
require('lspconfig').glsl_analyzer.setup({})

-- Setup snippets
require("luasnip.loaders.from_vscode").lazy_load()

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
local cmp_format = require('lsp-zero').cmp_format({details = true})

-- Setup autocompletion
cmp.setup({
  sources = {
    { name = 'nvim_lsp'},
		{ name = 'luasnip' },
    { name = 'buffer'  },
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
-- Setup latex specific
cmp.setup.filetype("tex", {
	sources = {
		{ name = 'vimtex' },
		{ name = 'luasnip'},
		{ name = 'buffer' },
	},
})

-- Custom keybindings
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<C-s>", ":w<CR>")

vim.keymap.set("n", "<Tab>", ":tabn<CR>")
vim.keymap.set("n", "<S-Tab>", ":tabp<CR>")
vim.keymap.set("n", "<C-n>", ":tabe ")

vim.keymap.set({"n", "t"}, "<A-i>", function () require("nvterm.terminal").toggle('float') end)
vim.keymap.set({"n", "t"}, "<A-h>", function () require("nvterm.terminal").toggle('horizontal') end)
