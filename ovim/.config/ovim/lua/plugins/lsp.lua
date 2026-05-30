local M = {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"williamboman/mason.nvim",
			opts = {
				registries = { "github:mason-org/mason-registry" },
			},
		},
		{ "williamboman/mason-lspconfig.nvim" },
	},
}

function M.config()
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("ovim-lsp-attach", { clear = true }),
		callback = function(event)
			local fzf = require("fzf-lua")
			local map = function(keys, func, desc, mode)
				vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
			end

			map("K", vim.lsp.buf.hover, "Hover Documentation")
			map("gd", function()
				fzf.lsp_definitions({ jump1 = true })
			end, "Goto Definition")
			map("gr", function()
				fzf.lsp_references({ includeDeclaration = false })
			end, "Goto References")
			map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "v" })
			map("<leader>rn", vim.lsp.buf.rename, "Rename")
			map("<leader>ld", function()
				vim.diagnostic.setqflist({ open = true })
			end, "Diagnostics to quickfix")
			map("[d", function()
				vim.diagnostic.jump({ count = -1 })
			end, "Prev Diagnostic")
			map("]d", function()
				vim.diagnostic.jump({ count = 1 })
			end, "Next Diagnostic")
			map("gl", vim.diagnostic.open_float, "Line Diagnostics")
		end,
	})

	vim.diagnostic.config({
		severity_sort = true,
		float = { border = "rounded", source = "if_many" },
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "󰅚 ",
				[vim.diagnostic.severity.WARN] = "󰀪 ",
				[vim.diagnostic.severity.INFO] = "󰋽 ",
				[vim.diagnostic.severity.HINT] = "󰌶 ",
			},
		},
		virtual_text = false,
	})

	require("mason-lspconfig").setup({
		ensure_installed = { "marksman" },
		automatic_installation = false,
	})

	local capabilities = require("blink.cmp").get_lsp_capabilities()

	vim.lsp.config("marksman", { capabilities = capabilities })
	vim.lsp.config("harper_ls", {
		capabilities = capabilities,
		settings = {
			["harper-ls"] = {
				linters = {
					sentence_capitalization = false, -- too aggressive for notes
					spell_check = true,
				},
			},
		},
	})

	vim.lsp.enable({ "marksman", "harper_ls" })
end

return M
