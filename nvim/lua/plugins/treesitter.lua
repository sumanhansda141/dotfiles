local M = {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-context",
		"folke/ts-comments.nvim",
	},
	event = { "VeryLazy" },
	build = ":TSUpdate",
}

function M.config()
	require("nvim-treesitter.configs").setup({
		-- Add languages to be installed here that you want installed for treesitter

		ensure_installed = {
			"bash",
			"c",
			"cpp",
			"diff",
			"html",
			"javascript",
			"jsdoc",
			"json",
			"jsonc",
			"lua",
			"luadoc",
			"luap",
			"go",
			"markdown",
			"markdown_inline",
			"printf",
			"python",
			"query",
			"regex",
			"sql",
			"toml",
			"tsx",
			"typescript",
			"vim",
			"vimdoc",
			"xml",
			"yaml",
		},
		context_commentstring = { enable = true },
		-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
		auto_install = false,

		highlight = { enable = true },
		indent = { enable = true, disable = { "python", "ocaml" } },
		incremental_selection = {
			enable = true,
		},
	})
end

return M
