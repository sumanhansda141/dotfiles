local M = {
	"UtkarshVerma/molokai.nvim",
	lazy = false,
	priority = 1000,
	opts = {},
}

function M.config()
	local colorscheme = "molokai"

	local status_ok, _ = pcall(vim.cmd.colorscheme, colorscheme)
	if not status_ok then
		return
	end

	local function CustomUiSettings()
		vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#FB508F", bold = true })
		vim.api.nvim_set_hl(0, "LineNr", { fg = "white", bold = true })
		vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#51B3EC", bold = true })
		-- Normal mode background
		vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
		vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

		-- Terminal background
		vim.api.nvim_set_hl(0, "Terminal", { bg = "NONE", ctermbg = "NONE" })

		-- Sign column background
		vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE", ctermbg = "NONE" })

		-- Diagnostic virtual text backgrounds
		vim.api.nvim_set_hl(0, "DiagnosticVirtualTextOk", { bg = "NONE", ctermbg = "NONE" })
		vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { bg = "NONE", ctermbg = "NONE" })
		vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { bg = "NONE", ctermbg = "NONE" })
		vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { bg = "NONE", ctermbg = "NONE" })
		vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { bg = "NONE", ctermbg = "NONE" })
	end

	-- Create an autocommand to set transparent background after VimEnter
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = CustomUiSettings,
	})

	-- If you want to ensure it works with colorschemes
	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = CustomUiSettings,
	})
end

return M
