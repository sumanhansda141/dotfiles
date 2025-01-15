local M = {
	"stevearc/conform.nvim",
	dependencies = {
		"mfussenegger/nvim-lint",
	},
	keys = {
		{
			"<leader>lf",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			desc = "[F]ormat [B]uffer",
		},
	},
}

function M.config()
	local conform = require("conform")
	local lint = require("lint")

	-- Configure linting with nvim-lint
	lint.linters_by_ft = {
		typescript = { "eslint" },
		javascript = { "eslint" },
		sh = { "shellcheck" },
		go = { "golangcilint" },
		python = { "ruff" },
	}

	-- Auto-trigger linting
	vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
		callback = function()
			require("lint").try_lint()
		end,
	})

	-- Configure conform.nvim for formatting
	conform.setup({
		default_format_opts = {
			timeout_ms = 3000,
			async = false, -- not recommended to change
			quiet = false, -- not recommended to change
			lsp_format = "fallback", -- not recommended to change
		},
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescriptreact = { "prettierd" },
			json = { "prettierd" },
			html = { "prettierd" },
			css = { "prettierd" },
			scss = { "prettierd" },
			markdown = { "prettierd" },
			yaml = { "prettierd" },
			sh = { "shfmt" },
			go = { "gofmt" },
			ocaml = { "ocamlformat" },
			rust = { "rustfmt" },
			python = { "black" },
		},
		-- Optional: Customize formatters
		formatters = {
			shfmt = {
				prepend_args = { "-i", "2", "-ci" },
			},
		},
	})
end

return M
