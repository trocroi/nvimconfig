local options = {
    autoindent = true,
    backgroud = "dark",
    cmdheight = 1,
    completeopt = {'menu', 'menuone', 'noselect'},
    conceallevel = 0,
    cursorline = true,
    expandtab = true,
    ignorecase = false,
    grepprg = 'rg --vimgrep --follow',
    laststatus = 3,
    list = true,
    mouse = "niv",
    number = true,
    numberwidth = 4,
    scrolloff = 8,
    shiftwidth = 4,
    showmode = false,
    showtabline = 4,
    signcolumn = 'yes',
    smartcase = true,
    splitbelow = true,
    splitright = true,
    swapfile = false,
    smartindent = true,
    softtabstop = 4,
    syntax = 'on',
    tabstop = 4,
    termguicolors = true,
    timeoutlen = 300, -- (ms) time to wait for a mapped sequence
    ttimeoutlen = 250, -- no idea here
    undofile = true, -- enable persistent undo
    updatetime = 100, -- (ms) faster completion, 400ms default
    clipboard = 'unnamedplus',
    wrap = true,
    wildignorecase = true
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

vim.opt.whichwrap:append "<>hl[]" -- go to prev/next line with movement keys

vim.opt.path:remove "/usr/include" -- better search
vim.opt.path:append "**" -- better search

vim.opt.errorformat:append('%f:%l:%c%p%m')

vim.opt.listchars:append({space = '·'})

vim.opt.wildignore:append "**/.git/*"

-- i don't know where to put these yet
vim.g.mapleader = ' '
vim.cmd.colorscheme('vscode')
