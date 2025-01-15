-- Disable backup and swap files to improve performance
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.writebackup = false

-- UI and Cursor Enhancements
vim.opt.number = true -- Show line numbers
vim.opt.rnu = true -- Relative line numbers
vim.opt.cursorline = true -- Highlight current line
vim.opt.cursorcolumn = true -- Highlight current column
vim.opt.scrolloff = 8 -- Keep 8 lines visible above/below cursor
vim.opt.sidescrolloff = 8 -- Keep 8 columns visible left/right of cursor
vim.opt.guicursor = "" -- Preserve terminal cursor style
vim.opt.signcolumn = "yes:2" -- Always show sign column
vim.opt.numberwidth = 4 -- Minimal width for line numbers

-- Editing Comfort
vim.opt.clipboard = "unnamedplus" -- System clipboard integration
vim.opt.mouse = "a" -- Enable mouse in all modes
vim.opt.iskeyword:append("-") -- Treat hyphenated words as single word
vim.opt.smartindent = true -- Smart autoindenting

-- Tab and Indentation
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 4 -- Indent width
vim.opt.tabstop = 4 -- Tab display width
vim.opt.softtabstop = 4 -- Tab insert width

-- Search and Case Sensitivity
vim.opt.hlsearch = true -- Highlight search results
vim.opt.ignorecase = true -- Ignore case in searches
vim.opt.smartcase = true -- Override ignorecase if search contains uppercase

-- Performance and Completion
vim.opt.updatetime = 300 -- Faster completion
vim.opt.timeoutlen = 1000 -- Timeout for mapped sequences
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.pumheight = 10 -- Popup menu height

-- Visual Indicators
vim.opt.list = true
vim.opt.listchars = {
	tab = "| ",
	trail = "·",
	nbsp = "␣",
	eol = "¬",
}

-- Text Wrapping
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.lbr = true

-- UI and Encoding
vim.opt.termguicolors = true -- Enable true color support
vim.opt.fileencoding = "utf-8"
vim.opt.conceallevel = 0 -- Show all text in markdown

-- Command and Status Line
vim.opt.cmdheight = 1
vim.opt.laststatus = 3 -- Global status line
vim.opt.showmode = false -- Hide mode indicator
vim.opt.showcmd = false -- Hide partial commands
vim.opt.ruler = false -- Hide cursor position

-- Split Behavior
vim.opt.splitbelow = true -- New splits below
vim.opt.splitright = true -- New splits to the right

-- Undo Persistence
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.local/share/nvim/undodir"

-- Misc
vim.opt.shortmess:append("c") -- Reduce completion messages
vim.opt.whichwrap:append("<,>,[,],h,l")
vim.opt.fillchars:append({ eob = " " })

-- Remove auto-comment continuation
vim.opt.formatoptions:remove({ "c", "r", "o", "l" })
