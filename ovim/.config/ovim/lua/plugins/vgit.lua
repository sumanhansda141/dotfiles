local M = {
	"tanvirtin/vgit.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
}

function M.config()
	require("vgit").setup({
		settings = {
			live_blame = {
				enabled = true,
			},
			live_gutter = {
				enabled = true,
				edge_navigation = true,
			},
			authorship_code_lens = {
				enabled = false,
			},
			scene = {
				diff_preference = "unified",
			},
			signs = {
				priority = 10,
				definitions = {
					GitSignsAdd = {
						linehl = nil,
						texthl = nil,
						numhl = nil,
						icon = nil,
						text = "▎",
					},
					GitSignsChange = {
						linehl = nil,
						texthl = nil,
						numhl = nil,
						icon = nil,
						text = "▎",
					},
					GitSignsDelete = {
						linehl = nil,
						texthl = nil,
						numhl = nil,
						icon = nil,
						text = "",
					},
				},
			},
			keymaps = {
				disabled = true, -- We'll define our own below
			},
		},
	})

	local vgit = require("vgit")
	local function map(mode, l, r, opts)
		vim.keymap.set(mode, l, r, opts or {})
	end

	-- Navigation
	map("n", "]h", function() vgit.hunk_down() end)
	map("n", "[h", function() vgit.hunk_up() end)

	-- Actions
	map("n", "<leader>hs", function() vgit.buffer_hunk_stage() end)
	map("n", "<leader>hr", function() vgit.buffer_hunk_reset() end)
	map("n", "<leader>hS", function() vgit.buffer_stage() end)
	map("n", "<leader>hR", function() vgit.buffer_reset() end)
	map("n", "<leader>hp", function() vgit.buffer_hunk_preview() end)
	map("n", "<leader>hb", function() vgit.buffer_blame_preview() end)
	map("n", "<leader>hd", function() vgit.buffer_diff_preview() end)
	map("n", "<leader>hD", function() vgit.project_diff_preview() end)
	map("n", "<leader>hq", function() vgit.project_hunks_qf() end)

	-- Toggles
	map("n", "<leader>tb", function() vgit.toggle_live_blame() end)
	map("n", "<leader>tw", function() vgit.toggle_diff_preference() end)

	-- Text object
	map({ "o", "x" }, "ih", function() vgit.hunk_select() end)
end

return M
