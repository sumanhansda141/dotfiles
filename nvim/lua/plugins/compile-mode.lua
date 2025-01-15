local M = {
	"ej-shafran/compile-mode.nvim",
	branch = "latest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "m00qek/baleia.nvim", tag = "v1.3.0" },
	},
	keys = {
		{ "<C-m>c", "<cmd>Compile<cr>" },
		{ "<C-m>r", "<cmd>Recompile<cr>" },
	},
    lazy = true,
}

function M.config()
	vim.g.compile_mode = {
		baleia_setup = true,
		default_command = "",
	}
end

return M
