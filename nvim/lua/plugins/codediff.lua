local M = {
	"esmuellert/codediff.nvim",
	cmd = "CodeDiff",
}

function M.config()
	require("codediff").setup({
		diff = {
			layout = "side-by-side", -- or "inline"
			jump_to_first_change = true,
			cycle_next_hunk = true,
		},
		explorer = {
			position = "left",
			width = 40,
		},
	})

	local function diffOpenWithInput()
		local user_input = vim.fn.input("Revision to Open: ")
		vim.cmd("CodeDiff " .. user_input)
	end

	local function diffOpenFileHistory()
		local user_input = vim.fn.input("Files to Open: ")
		-- If empty, default to current dir
		if user_input == "" then
			vim.cmd("CodeDiff history")
		else
			vim.cmd("CodeDiff history HEAD " .. user_input)
		end
	end

	-- Here are some ways I commonly call it:
	-- 1. diffOpenFileHistory with . opens commit wise history of entire codebase.
	-- 2. diffOpenFileHistory with % opens commit wise history of current file.
	-- 3. diffOpenFileHistory with <any file path> opens commit wise history of that file.
	-- 4. diffOpenWithInput with HEAD opens diff of latest commit.
	-- 5. diffOpenWithInput with HEAD~3 opens diff of last 3 commits.
	-- 6. diffOpenWithInput with master..HEAD opens changes of your feature branch.
	vim.keymap.set("n", "<leader>df", diffOpenFileHistory, { desc = "Open CodeDiff File History" })
	vim.keymap.set("n", "<leader>do", diffOpenWithInput, { desc = "Open CodeDiff" })
	vim.keymap.set("n", "<leader>dg", "<cmd>CodeDiff<CR>", { desc = "Open CodeDiff Explorer" })
	vim.keymap.set("n", "<leader>dc", "<cmd>q<CR>", { desc = "Close CodeDiff" })
end

return M
