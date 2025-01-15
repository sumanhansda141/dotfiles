local M = {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
}

function M.config()
	require("neo-tree").setup({
		event_handlers = {
			{
				event = "neo_tree_buffer_enter",
				handler = function()
					vim.cmd([[
                      setlocal relativenumber
                    ]])
				end,
			},
		},
		window = {
			position = "float",
			width = 30,
			mapping_options = {
				noremap = true,
				nowait = true,
			},
			mappings = {
				["/"] = "noop",
				["l"] = "open",
				["h"] = "close_node",
                ["gh"] = "toggle_hidden",
				["<space>"] = "none",
				["Y"] = {
					function(state)
						local node = state.tree:get_node()
						local path = node:get_id()
						vim.fn.setreg("+", path, "c")
					end,
					desc = "Copy Path to Clipboard",
				},
				["O"] = {
					function(state)
						require("lazy.util").open(state.tree:get_node().path, { system = true })
					end,
					desc = "Open with System Application",
				},
				["P"] = { "toggle_preview" },
				-- Netrw-like mappings
				["-"] = "navigate_up", -- Go up one directory
				["D"] = "delete",
				["R"] = "rename",
				["d"] = "add_directory",
				["%"] = "add", -- Create new file
			},
		},
		filesystem = {
			filtered_items = {
				visible = false,
				hide_dotfiles = true,
				hide_gitignored = true,
			},
			follow_current_file = {
				enabled = true,
			},
			use_libuv_file_watcher = true,
		},
		default_component_configs = {
			indent = {
				with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
				expander_collapsed = "",
				expander_expanded = "",
				expander_highlight = "NeoTreeExpander",
			},
			git_status = {
				symbols = {
					unstaged = "󰄱",
					staged = "󰱒",
				},
			},
		},
	})

	-- Optional: Set up a keymap to toggle Neo-tree
	-- Similar to how :Lexplore toggles netrw
	vim.api.nvim_set_keymap("n", "<Leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true })
end

return M
