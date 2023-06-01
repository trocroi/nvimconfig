-- [[
-- this is best practice for a block comment
-- first init action is to set the global and local leaders
-- ]]
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- disable netrw at the very start of your init.lua for NvimTree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Install package manager
  -- https://github.com/folke/lazy.nvim
  -- `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)


-- Here is where you install your plugins.
-- There are a few ways that you can configure a plugin.
--
-- 1) using the lua form
--      require('<plugin_name>').setup({ <params> })
--
-- 2) where the plugin is loaded inside the 'lazy'.setup( {} )... using 
--      opts = {}
--
-- 3) inside cBrace after specifying the plugin name using the `config` key
--      { 'author/plugin-name', config = true }
--
-- 4) configure plugins after the setup call,
--    as they will be available in your neovim runtime.
--
-- REMEMBER: `opts = {}` is the same as calling `require('<plugin_name>').setup({ <params> })` separately

-- set up the lazy.nvim plugin and install/configure all the plugins.
require('lazy').setup({

  -- NOTE: plugins that don't require configuration don't need to be wrapped in curly braces
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'tpope/vim-surround',
  'jremmen/vim-ripgrep',
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  -- autopairs braces etc
  {"windwp/nvim-autopairs", opts = {} },

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  --  Often, the lsp-config is done in a completely separate lsp.lua or lsp/init.lua file
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },
  --
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },

  -- GitSigns adds git stuff to the gutter
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '[c', require('gitsigns').prev_hunk, { buffer = bufnr, desc = 'Go to Previous Hunk' })
        vim.keymap.set('n', ']c', require('gitsigns').next_hunk, { buffer = bufnr, desc = 'Go to Next Hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },

  -- color schemes and pretty things ----------------------------
  {
    'navarasu/onedark.nvim',
    opts = {
      italic_comments = false,
    }
  },
  -- {
  --   'folke/tokyonight.nvim',
  --   opts = {
  --     italic_comments = false,
  --   }
  -- },
  'morhetz/gruvbox',
  'nordtheme/vim',
  {
    'mofiqul/vscode.nvim',
    opts = {
      italic_comments = false,
    }
  },

  {
    -- set lualine as statusline
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        disabled_filetypes = {
          statusline = {'NvimTree'}
        }
      },
    },
  },

  {
    -- add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- enable `lukas-reineke/indent-blankline.nvim`
    -- see `:help indent_blankline.txt`
     opts = {
       char = '┊', -- try '|' as well or other vertical bars like from !tree
       show_trailing_blankline_indent = false,
       show_first_indent_level = false,
       use_treesitter = true,
       show_current_context = true,
    },
  },

  -- to comment visual regions/lines
  { 'numtostr/comment.nvim',
    opts = {
      -- LHS of operator-pending mappings in NORMAL and VISUAL mode
      opleader = {
        -- Line-comment keymap
        line = '<leader>cl',
        -- Block-comment keymap
        block = '<leader>cb',
      },
    }
  },

  { 'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {}
  },

  -- fuzzy finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- fuzzy finder algorithm which requires local dependencies to be built.
  -- only load if `make` is available. make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- note: if you are having trouble with this installation,
    --       refer to the readme for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    -- highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':tsupdate',
  },

  -- note: next step on your neovim journey: add/configure additional "plugins" for kickstart
  --       these are some example plugins that i've included in the kickstart repository.
  --       uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- note: the import below automatically adds your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    you can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --
  --    for additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
}, {})


-- [[ setting options ]]
-- see `:help vim.o`
-- note: you can change these options as you wish!

-- first, set color scheme because color is the most important lol
vim.cmd.colorscheme('gruvbox') -- ("vscode")
-- default tablstop and shiftwidth to 4
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
-- expand tab to spaces always
vim.opt.expandtab = true
-- because this is nice
vim.opt.autoindent = true
vim.opt.smartindent = true
-- show whitespace as 'middot' char
vim.opt.listchars:append({ space = '·' })
vim.opt.list = true
vim.opt.syntax = 'on'
-- word wrap for narrow panes/windows/buffers
vim.opt.wrap = true
-- the number of lines _below_ the cursor to keep when scrolling to top or bottom of buffer
vim.opt.scrolloff = 8
-- show the cursor's line and column
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
-- update the 'grep program' to use the rg
vim.opt.grepprg = 'rg --vimgrep --follow'
-- error format for ?
vim.opt.errorformat:append('%f:%l:%c%p%m')
-- allow cursor movement to wrap forward/back around end-of-line and start-of-line
vim.opt.whichwrap:append("hl<>[]")

-- Set highlight on search
vim.o.hlsearch = true
-- bind <ESC> to `:noh` to clear search highlight "nnoremap <esc> :noh<return><esc>"
vim.api.nvim_set_keymap('n', '<esc>', ":noh<return><esc>", { noremap = true, silent=true })

-- Show line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.opt.clipboard:append('unnamedplus')
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250 -- 100? 150? 
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- always open split windows to the right or below
vim.opt.splitbelow = true
vim.opt.splitright = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
    layout_config = {
      horizontal = {
        width = 0.95,
        height = 0.95,
        prompt_position = 'top'
      }
    }
  },
  pickers = {
    colorscheme = {
      enable_preview = true
    },
    oldfiles = {
      layout_strategy = 'center',
      previewer = false,
      layout_config = {
        anchor = 'N'
      }
    },
    buffers = {
      layout_strategy = 'center',
      previewer = false,
      layout_config = {
        anchor = 'N'
      }
    },
    live_grep = {},
    find_files = {
      layout_strategy = 'center',
      previewer = false,
      layout_config = {
        anchor = 'N'
      },
    },
    current_buffer_fuzzy_find = {
      layout_strategy = 'bottom_pane',
      previewer = true,
      layout_config = {
        height = 0.5,
        prompt_position = 'bottom'
      }
    }
  }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope keymaps
local tscope = require('telescope.builtin')
vim.keymap.set('n', '<leader><space>', tscope.buffers, { desc = 'List currently open buffers' })
vim.keymap.set('n', '<leader>th', tscope.colorscheme, { desc = 'Select color scheme with preview'})
vim.keymap.set('n', '<leader>fo', tscope.oldfiles, { desc = 'Telescope [F]ind recently [O]pen files'})
-- vim.keymap.set('n', '<leader>fg', tscope.git_files, { desc = 'Search [F]iles tracked by [G]it' })
vim.keymap.set('n', '<leader>ff', tscope.find_files, { desc = '[F]ind [F]iles in cwd'})
vim.keymap.set('n', '<leader>fl', tscope.live_grep, { desc = '[F]ind [L]ive grep search term in workspace' })
vim.keymap.set('n', '<leader>/', tscope.current_buffer_fuzzy_find, { desc = '[/] fuzzy find in current buffer'})

-- [[ Configure NvimTree ]]
require("nvim-tree").setup {
  disable_netrw = true,
  view = {
    width = 80,
  },
  actions = {
    open_file = {
      quit_on_open = true
    }
  }
}
vim.keymap.set('n', '<leader>e', require('nvim-tree.api').tree.toggle, {desc = "open file tr[e]e"})

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'markdown', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim' },
  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  -- textobjects = {
  --   select = {
  --         enable = true,
  --     lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      -- keymaps = {
      --   -- You can use the capture groups defined in textobjects.scm
      --   ['aa'] = '@parameter.outer',
      --   ['ia'] = '@parameter.inner',
      --   ['af'] = '@function.outer',
      --   ['if'] = '@function.inner',
      --   ['ac'] = '@class.outer',
      --   ['ic'] = '@class.inner',
      -- },
    -- },
    -- -- move = {
    --   enable = true,
    --   set_jumps = true, -- whether to set jumps in the jumplist
    --   goto_next_start = {
    --     [']m'] = '@function.outer',
    --     [']]'] = '@class.outer',
    --   },
    --   goto_next_end = {
    --     [']M'] = '@function.outer',
    --     [']['] = '@class.outer',
    --   },
    --   goto_previous_start = {
    --     ['[m'] = '@function.outer',
    --     ['[['] = '@class.outer',
    --   },
    --   goto_previous_end = {
    --     ['[M'] = '@function.outer',
    --     ['[]'] = '@class.outer',
    --   },
    -- },
    -- swap = {
    --   enable = true,
    --   swap_next = {
    --     ['<leader>a'] = '@parameter.inner',
    --   },
    --   swap_previous = {
    --     ['<leader>A'] = '@parameter.inner',
    --   },
    -- },
--   },
}

-- Diagnostic keymaps
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>lr', vim.lsp.buf.rename, '[L]SP [R]ename')
  nmap('<leader>la', vim.lsp.buf.code_action, '[L]SP Code [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
