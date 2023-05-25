local lazy = {}

function lazy.install(path)
  if not vim.loop.fs_stat(path) then
    print('Installing lazy.nvim....')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      path,
    })
  end
end

local key_mapper = function(mode, key, result)
  vim.api.nvim_set_keymap(
    mode,
    key,
    result,
    {noremap = true, silent = true}
  )
end

function lazy.setup(plugins)
  -- You can "comment out" the line below after lazy.nvim is installed
  lazy.install(lazy.path)

  vim.opt.rtp:prepend(lazy.path)
  require('lazy').setup(plugins, lazy.opts)
end

lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {}

lazy.setup({
  -- color schemes
  {'folke/tokyonight.nvim'},
  {'morhetz/gruvbox'},
  {'Mofiqul/vscode.nvim'},
  -- telescope
  {
  'nvim-telescope/telescope.nvim', tag = '0.1.1',
  dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
  {'neovim/nvim-lspconfig'},
  {'nvim-lua/completion-nvim'},
  {'anott03/nvim-lspinstall'},
  {'nvim-lua/popup.nvim'},
  {'jremmen/vim-ripgrep'},
  {'sharkdp/fd'},
  {'nvim-lualine/lualine.nvim'},
  {'lukas-reineke/indent-blankline.nvim'},
  {'tpope/vim-surround'},
})

vim.opt.termguicolors = true
vim.cmd.colorscheme('vscode')
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.listchars:append({
    space = '·'
})
vim.opt.list = true
vim.opt.syntax = 'on'
vim.opt.wrap = true
vim.g.mapleader = ' '
vim.opt.scrolloff = 2
vim.opt.cursorline = true
vim.opt.completeopt = {'menu', 'menuone'}
vim.opt.grepprg = 'rg --vimgrep --follow'
vim.opt.errorformat:append('%f:%l:%c%p%m')
vim.opt.clipboard:append('unnamedplus')
vim.opt.whichwrap = "h,l,<,>,[,],b,s"


require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "python"},
    highlight = {
        enable = true
    },
}

local lspconfig = require'lspconfig'
local completion = require'completion'

local function custom_on_attach(client)
  print('Attaching to ' .. client.name)
  completion.on_attach(client)
end

local default_config = {
  on_attach = custom_on_attach,
}
-- setup language servers here
lspconfig.tsserver.setup(default_config)

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = false,
    signs = true,
    update_in_insert = true,
  }
)


require('lualine').setup({
    options = {
    icons_enabled = true,
    theme = 'vscode',
    component_separators = '|',
    -- section_separators = '',
    disabled_filetypes = {
      statusline = {'NvimTree'}
    }
  },
})

require('vscode').setup({
    italic_comments = true,
})

require('indent_blankline').setup({
  char = '|',
  show_trailing_blankline_indent = true,
  show_first_indent_level = false,
  use_treesitter = true,
  show_current_context = false
})

key_mapper('n', 'gd', ':lua vim.lsp.buf.definition()<CR>')
key_mapper('n', 'gD', ':lua vim.lsp.buf.declaration()<CR>')
key_mapper('n', 'gi', ':lua vim.lsp.buf.implementation()<CR>')
key_mapper('n', 'gw', ':lua vim.lsp.buf.document_symbol()<CR>')
key_mapper('n', 'gW', ':lua vim.lsp.buf.workspace_symbol()<CR>')
key_mapper('n', 'gr', ':lua vim.lsp.buf.references()<CR>')
key_mapper('n', 'gt', ':lua vim.lsp.buf.type_definition()<CR>')
key_mapper('n', 'K', ':lua vim.lsp.buf.hover()<CR>')
key_mapper('n', '<c-k>', ':lua vim.lsp.buf.signature_help()<CR>')
key_mapper('n', '<leader>af', ':lua vim.lsp.buf.code_action()<CR>')
key_mapper('n', '<leader>rn', ':lua vim.lsp.buf.rename()<CR>')
key_mapper('n', '<leader>ff', ':lua require"telescope.builtin".find_files()<CR>')
key_mapper('n', '<leader>fg', ':lua require"telescope.builtin".live_grep<cr>')
key_mapper('n', '<leader>fo', ':lua require"telescope.builtin".oldfiles<cr>')
key_mapper('n', '<leader>fh', ':lua require"telescope.builtin".help_tags()<CR>')
key_mapper('n', '<leader>fb', ':lua require"telescope.builtin".current_buffer_fuzzy_find<CR>')
