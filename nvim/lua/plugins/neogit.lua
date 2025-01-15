local M = {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "<leader>gg", "<cmd>Neogit<CR>" },
	},
	config = true,
}

function M.config()
	require("neogit").setup({
		integrations = {
			diffview = true,
		},
		disable_relative_line_numbers = false,
		mappings = {
			status = {
				["1"] = false,
				["2"] = false,
				["3"] = false,
				["4"] = false,
			},
		},
	})
end

return M
