-- Statusline configuration
local modes = {
	["n"] = "NORMAL",
	["no"] = "NORMAL",
	["v"] = "VISUAL",
	["V"] = "VISUAL LINE",
	["␖"] = "VISUAL BLOCK",
	["s"] = "SELECT",
	["S"] = "SELECT LINE",
	["␓"] = "SELECT BLOCK",
	["i"] = "INSERT",
	["ic"] = "INSERT",
	["R"] = "REPLACE",
	["Rv"] = "VISUAL REPLACE",
	["c"] = "COMMAND",
	["cv"] = "VIM EX",
	["ce"] = "EX",
	["r"] = "PROMPT",
	["rm"] = "MOAR",
	["r?"] = "CONFIRM",
	["!"] = "SHELL",
	["t"] = "TERMINAL",
}

local function mode()
	local current_mode = vim.api.nvim_get_mode().mode
	return string.format(" %s ", modes[current_mode]):upper()
end

local function update_mode_colors()
	local current_mode = vim.api.nvim_get_mode().mode
	local mode_color = "%#StatusLineAccent#"
	if current_mode == "n" then
		mode_color = "%#StatuslineAccent#"
	elseif current_mode == "i" or current_mode == "ic" then
		mode_color = "%#StatuslineInsertAccent#"
	elseif current_mode == "v" or current_mode == "V" or current_mode == "␖" then
		mode_color = "%#StatuslineVisualAccent#"
	elseif current_mode == "R" then
		mode_color = "%#StatuslineReplaceAccent#"
	elseif current_mode == "c" then
		mode_color = "%#StatuslineCmdLineAccent#"
	elseif current_mode == "t" then
		mode_color = "%#StatuslineTerminalAccent#"
	end
	return mode_color
end

local function filepath()
	local fpath = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.:h")
	if fpath == "" or fpath == "." then
		return " "
	end
	return string.format(" %%<%s/", fpath)
end

local function filename()
	local fname = vim.fn.expand("%:t")
	if fname == "" then
		return ""
	end
	return fname .. " "
end

local function lsp()
	local count = {
		errors = 0,
		warnings = 0,
		info = 0,
		hints = 0,
	}

	local levels = {
		errors = vim.diagnostic.severity.ERROR,
		warnings = vim.diagnostic.severity.WARN,
		info = vim.diagnostic.severity.INFO,
		hints = vim.diagnostic.severity.HINT,
	}

	for k, level in pairs(levels) do
		count[k] = #vim.diagnostic.get(0, { severity = level })
	end

	local errors = count["errors"] > 0 and (" %#DiagnosticError#E " .. count["errors"]) or ""
	local warnings = count["warnings"] > 0 and (" %#DiagnosticWarn#W " .. count["warnings"]) or ""
	local hints = count["hints"] > 0 and (" %#DiagnosticHint#H " .. count["hints"]) or ""
	local info = count["info"] > 0 and (" %#DiagnosticInfo#I " .. count["info"]) or ""

	return errors .. warnings .. hints .. info .. "%#Normal#"
end

local function filetype()
	return string.format(" %s ", vim.bo.filetype):upper()
end

local function lineinfo()
	if vim.bo.filetype == "alpha" then
		return ""
	end
	return " %P %l:%c "
end

local function vcs()
	local git_info = vim.b.gitsigns_status_dict
	if not git_info or git_info.head == "" then
		return ""
	end
	local added = git_info.added and ("%#GitSignsAdd#+" .. git_info.added .. " ") or ""
	local changed = git_info.changed and ("%#GitSignsChange#~" .. git_info.changed .. " ") or ""
	local removed = git_info.removed and ("%#GitSignsDelete#-" .. git_info.removed .. " ") or ""
	if git_info.added == 0 then
		added = ""
	end
	if git_info.changed == 0 then
		changed = ""
	end
	if git_info.removed == 0 then
		removed = ""
	end
	return table.concat({
		" ",
		added,
		changed,
		removed,
		" ",
		"%#GitSignsAdd# ",
		git_info.head,
		" %#Normal#",
	})
end

local function noice_mode()
	local noice_ok, noice = pcall(require, "noice")
	if not noice_ok then
		return ""
	end

	local noice_status = noice.api.status.mode.get()
	return noice_status and ("%#NoiceModeAccent#" .. noice_status .. " ") or ""
end

local arrow = require("arrow.statusline")

Statusline = {}

Statusline.active = function()
	return table.concat({
		"%#Statusline#",
		update_mode_colors(),
		mode(),
        noice_mode(),
		vcs(),
		"%#Normal# ",
		"%=%#StatusLineExtra#",
		"%#Normal# ",
		arrow.text_for_statusline_with_icons(),
		filepath(),
		filename(),
		"%m",
		"%#Normal#",
		"%=%#StatusLineExtra#",
		lsp(),
		filetype(),
		lineinfo(),
	})
end

Statusline.inactive = function()
	return " %F"
end

-- Create an augroup for the Statusline
local statusline_group = vim.api.nvim_create_augroup("Statusline", { clear = true })

-- Create autocommands for active windows/buffers
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	group = statusline_group,
	callback = function()
		vim.wo.statusline = "%!v:lua.Statusline.active()"
	end,
})

-- Create autocommands for inactive windows/buffers
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
	group = statusline_group,
	callback = function()
		vim.wo.statusline = "%!v:lua.Statusline.inactive()"
	end,
})
