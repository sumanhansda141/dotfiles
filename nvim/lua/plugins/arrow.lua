local M = {
	"otavioschwanck/arrow.nvim",
}

function M.config()
	require("arrow").setup({
		show_icons = true,
		leader_key = "<C-a>",
		buffer_leader_key = "m", -- Per Buffer Mappings
		mappings = {
			quit = "<C-c>",
		},
	})

	vim.keymap.set("n", "H", require("arrow.persist").previous)
	vim.keymap.set("n", "L", require("arrow.persist").next)
	vim.keymap.set("n", "<C-s>", require("arrow.persist").toggle)
end

return M
