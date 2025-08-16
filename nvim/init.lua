vim.o.winborder = "rounded"
-- Indenting stuff
vim.o.tabstop = 4
vim.o.smartindent = false
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.signcolumn = "yes"
vim.o.number = true
vim.o.relativenumber = true
vim.o.undofile = true
-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.o.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- vim.o.cursorline = true
vim.o.clipboard = "unnamedplus" -- Yank to system clipboard
vim.o.smoothscroll = true
vim.o.termguicolors = true
vim.o.ignorecase = true -- Ignore casing when searching
vim.o.smartcase = true  -- Turn off Ignore case when a capital letter is detected

vim.pack.add({
    { src = 'https://github.com/neovim/nvim-lspconfig'},
    { src = 'https://github.com/saghen/blink.cmp',
        version = vim.version.range('1.*'),
    },
    { src = 'https://github.com/Saghen/blink.compat'},
    { src = 'https://github.com/micangl/cmp-vimtex'},
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter',},
    { src = 'https://github.com/lervag/vimtex' },
    { src = "https://github.com/chomosuke/typst-preview.nvim",
        version = vim.version.range('1.*'),
    },
    -- { src = 'https://github.com/L3MON4D3/LuaSnip' },
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },
    { src = 'https://github.com/numToStr/FTerm.nvim', },
    { src = 'https://github.com/catppuccin/nvim'},
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://github.com/echasnovski/mini.pick" },
    { src = "https://github.com/windwp/nvim-autopairs" },
})

-- setup auto brackets
require "nvim-autopairs".setup({})
local Rule = require('nvim-autopairs.rule')
local npairs = require('nvim-autopairs')

npairs.add_rule(Rule("$","$",{"tex", "latek", "typ", "typst"})) -- Inserto double $ in tex and typst files

require "mini.pick".setup({})

require "typst-preview".setup({
    open_cmd = 'if [ $(ps -aux | grep \'firefox -P APP\' | wc -l) = \'3\' ]; then firefox -P APP -url %s 2> /dev/null ; fi',
    port = 12000,
     dependencies_bin = {
        ['tinymist'] = nil,
    }
})

require "blink.compat".setup({})

-- Setup autocompletion
require "blink.cmp".setup({
    keymap = { 
        preset = 'enter',

        ['<Up>'] = false,
        ['<Down>'] = false,

        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
    },

    signature = { enabled = true },
    completion = {
        list = { selection = { 
            preselect = false,
            auto_insert = false,
        }, }, 
        ghost_text = { enabled = true },
    },

    appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
    },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        per_filetype = {
            tex = {'vimtex'},
        },

        providers = {
            vimtex = {
                name = 'vimtex',
                module = 'blink.compat.source',

            },
        },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
})

-- Setup LSPs
vim.lsp.enable({
    'hls',
    'clangd',
    'pyright',
    'glsl_analyzer',
    'tinymist'
})
require('nvim-treesitter.configs').setup({ 
    highlight = { enable = true, },
    ensure_installed = { "bash", "c", "css", "cpp", "glsl", "haskell", "html", "javascript","lua", "python", "typst" },
    indent = { enable = true, },
})

-- Setup floating terminal
require('FTerm').setup({
    border = 'rounded',
    dimensions  = {
        height = 0.6,
        width = 0.5,
    },
})

-- Setup keymaps for git files
require('gitsigns').setup({
    on_attach = function(bufnr)
        vim.keymap.set("n", "<leader>gb", ":Gitsigns blame_line<CR>")
        vim.keymap.set("n", "<leader>gd", ":Gitsigns diffthis main<CR>")

        local gitsigns = require('gitsigns')

        vim.keymap.set('n', ']c', function()
            if vim.wo.diff then
                vim.cmd.normal({']c', bang = true})
            else
                gitsigns.nav_hunk('next')
            end
        end)

        vim.keymap.set('n', '[c', function()
            if vim.wo.diff then
                vim.cmd.normal({'[c', bang = true})
            else
                gitsigns.nav_hunk('prev')
            end
        end)

        vim.keymap.set("n", "<leader>cr", function()
            local openPop = io.popen(string.format('( cd $(dirname %s 2> /dev/null) 2> /dev/null && git rev-parse --show-toplevel 2>&1 )', vim.fn.expand("%:p") ), 'r')
            local output = openPop:read('*all')
            openPop:close()

            if string.sub(output, 1, 1) == "/" then vim.cmd(string.format("cd %s", output)) end
        end
)
    end
})

-- Set color scheme
require("catppuccin").setup({
    transparent_background = true,
    integrations = {
        cmp = true,
        gitsigns = true,
        treesitter = true,
        -- harpoon = true,
        -- telescope = true,
        -- mason = true,
        -- noice = true,
        -- notify = true,
        which_key = true,
        -- fidget = true,
        blink_cmp = {
            style = "bordered";
        },
        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = { "italic" },
                hints = { "italic" },
                warnings = { "italic" },
                information = { "italic" },
            },
            underlines = {
                errors = { "underline" },
                hints = { "underline" },
                warnings = { "underline" },
                information = { "underline" },
            },
            inlay_hints = {
                background = true,
            },
        },
    },
    custom_highlights = function(colors)
        return {
            CursorLine = { 
                underline = true,
                bg = "#000000",
            },
        }
    end
})
vim.cmd.colorscheme "catppuccin-mocha"


-- VimTeX options
vim.g.vimtex_view_method = "general"
vim.g.vimtex_view_general_viewer = "okular"
vim.g.vimtex_view_general_options = "--unique file:@pdf\\#src:@line@tex"
vim.g.vimtex_indent_enabled = 0

-- Custom keybindings
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<C-s>", ":w<CR>")

vim.keymap.set('n', '<A-i>', '<CMD>lua require("FTerm").toggle()<CR>')
vim.keymap.set('t', '<A-i>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

vim.keymap.set("n", "<Leader>tp", ":TypstPreviewToggle<CR>")
vim.keymap.set("n", "<Leader>tc", ":TypstPreviewFollowCursorToggle<CR>")

vim.keymap.set("n", "N", "<cmd>lua vim.diagnostic.open_float()<cr>")

vim.keymap.set("n", "<leader>ff", ":Pick files<CR>")
vim.keymap.set("n", "<leader>fg", ":Pick grep_live<CR>")
vim.keymap.set("n", "<leader>fb", ":Pick buffers<CR>")
vim.keymap.set("n", "<leader>fr", ":Pick resume<CR>")
vim.keymap.set("n", "<leader>fh", ":Pick help<CR>")

vim.keymap.set("n", "<leader>ch", ":cd $HOME<CR>")
vim.keymap.set("n", "<leader>ct", ":cd %:h<CR>")
vim.keymap.set("n", "<leader>cb", ":cd -<CR>")
