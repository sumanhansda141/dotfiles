local M = {
	"craftzdog/solarized-osaka.nvim",
	lazy = false,
	priority = 1000,
	opts = {},
}

-- Solarized canonical palette
local sol = {
	-- Base tones
	base03 = "#002b36", -- dark bg
	base02 = "#073642", -- dark bg highlights
	base01 = "#586e75", -- dark comments / light emphasized content
	base00 = "#657b83", -- dark body text / light optional emphasized content
	base0 = "#839496", -- dark body text
	base1 = "#93a1a1", -- dark comments
	base2 = "#eee8d5", -- light bg highlights
	base3 = "#fdf6e3", -- light bg
	-- Accent colors
	yellow = "#b58900",
	orange = "#cb4b16",
	red = "#dc322f",
	magenta = "#d33682",
	violet = "#6c71c4",
	blue = "#268bd2",
	cyan = "#2aa198",
	green = "#859900",
}

function M.config()
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			vim.cmd.colorscheme("solarized-osaka")
		end,
	})

	local function apply_highlights()
		local dark = vim.opt.background:get() == "dark"
		local bg = dark and sol.base03 or sol.base3
		local bg_hi = dark and sol.base02 or sol.base2
		local fg = dark and sol.base0 or sol.base00
		local dim = dark and sol.base01 or sol.base1

		-- Line numbers: magenta above, white/base0 current, blue below
		vim.api.nvim_set_hl(0, "LineNrAbove", { fg = sol.magenta, bold = true })
		vim.api.nvim_set_hl(0, "LineNr", { fg = fg, bold = true })
		vim.api.nvim_set_hl(0, "LineNrBelow", { fg = sol.blue, bold = true })

		-- Transparent backgrounds (keep terminal transparency intact)
		for _, group in ipairs({ "Normal", "NormalNC", "NormalFloat", "Terminal", "SignColumn" }) do
			vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
		end

		-- Diagnostic virtual text: no bg, use Solarized accent fg
		vim.api.nvim_set_hl(0, "DiagnosticVirtualTextOk", { fg = sol.green, bg = "NONE" })
		vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = sol.cyan, bg = "NONE" })
		vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = sol.blue, bg = "NONE" })
		vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = sol.yellow, bg = "NONE" })
		vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = sol.red, bg = "NONE" })

		-- Treesitter context: blue underline, dimmed line numbers
		vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { fg = sol.blue })
		vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true, sp = sol.blue })

		-- Status line: subtle cyan on bg highlight
		vim.api.nvim_set_hl(0, "StatusLine", { fg = sol.cyan, bg = bg_hi })

		-- Diff highlights using Solarized accent tones
		if dark then
			vim.api.nvim_set_hl(0, "DiffAdd", { bold = true, fg = "NONE", bg = "#1a3a2a" }) -- green tinted base02
			vim.api.nvim_set_hl(0, "DiffDelete", { bold = true, fg = "NONE", bg = "#3a1a1a" }) -- red tinted base02
			vim.api.nvim_set_hl(0, "DiffChange", { bold = true, fg = "NONE", bg = "#1a2d3a" }) -- blue tinted base02
			vim.api.nvim_set_hl(0, "DiffText", { bold = true, fg = "NONE", bg = "#2a2040" }) -- violet tinted base02
		else
			vim.api.nvim_set_hl(0, "DiffAdd", { bold = true, fg = "NONE", bg = "#d8e8c8" }) -- green tinted base2
			vim.api.nvim_set_hl(0, "DiffDelete", { bold = true, fg = "NONE", bg = "#f0d0cc" }) -- red tinted base2
			vim.api.nvim_set_hl(0, "DiffChange", { bold = true, fg = "NONE", bg = "#ccdde8" }) -- blue tinted base2
			vim.api.nvim_set_hl(0, "DiffText", { bold = true, fg = "NONE", bg = "#ddd0e8" }) -- violet tinted base2
		end
	end

	vim.api.nvim_create_autocmd("VimEnter", { callback = apply_highlights })
	vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_highlights })
end

return M
