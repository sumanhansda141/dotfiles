local build_commands = {
	c = "!g++ -std=c++17 -o %:p:r.o %",
	cpp = "!g++ -std=c++17 -Wall -O2 -o %:p:r.o %",
	rust = "!cargo build --release",
	go = "!go build",
	-- tex = "pdflatex %",
	tex = "VimtexCompile",
	javascript = "",
	java = "!javac %",
}

local debug_build_commands = {
	c = "!g++ -std=c++17 -g -o %:p:r.o %",
	cpp = "!g++ -std=c++17 -g -o %:p:r.o %",
	rust = "!cargo build",
	go = "!go build",
}

local run_commands = {
	c = "%:p:r.o",
	cpp = "%:p:r.o",
	rust = "cargo run --release",
	-- go = "%:p:r.o",
	go = "go run .",
	-- tex = "open %:p:r.pdf",
	tex = "",
	python = "python3 %",
	javascript = "node %",
	typescript = "bun %",
	java = "java %",
}

vim.api.nvim_create_user_command("Build", function()
	local filetype = vim.bo.filetype

	for file, command in pairs(build_commands) do
		if filetype == file then
			vim.cmd(command)
			break
		end
	end
end, {})

vim.api.nvim_create_user_command("DebugBuild", function()
	local filetype = vim.bo.filetype

	for file, command in pairs(debug_build_commands) do
		if filetype == file then
			vim.cmd(command)
			break
		end
	end
end, {})

function Split_term_execution(command)
	vim.cmd("sp")
	vim.cmd("term " .. command)
	vim.cmd("resize 15N")
	local keys = vim.api.nvim_replace_termcodes("i", true, false, true)
	vim.api.nvim_feedkeys(keys, "n", false)
end

vim.api.nvim_create_user_command("Run", function()
	local filetype = vim.bo.filetype

	for file, command in pairs(run_commands) do
		if filetype == file then
			Split_term_execution(command)
			break
		end
	end
end, {})

vim.api.nvim_create_user_command("Ha", function()
	vim.cmd([[Build]])
	vim.cmd([[Run]])
end, {})

vim.api.nvim_create_user_command("Config", function()
	vim.cmd([[cd ~/.config/nvim]])
end, {})

vim.api.nvim_create_user_command("UpdateAll", function()
	vim.cmd([[TSUpdateSync]])
	vim.cmd([[MasonUpdate]])
end, {})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
