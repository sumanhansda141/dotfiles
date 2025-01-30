local M = {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"williamboman/mason.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "luvit-meta/library", words = { "vim%.uv" } },
				},
			},
		},
		{ "Bilal2453/luvit-meta", lazy = true },
		"mfussenegger/nvim-jdtls",
	},
}

function M.config()
	-- Configure diagnostic display
	vim.diagnostic.config({
		virtual_text = {
			prefix = "●",
			spacing = 4,
			source = "if_many",
		},
		signs = true,
		underline = true,
		update_in_insert = false,
		severity_sort = true,
		float = {
			border = "rounded",
			source = "if_many",
			header = "",
			prefix = "",
		},
	})

	local lspconfig = require("lspconfig")

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
	-- Common LSP settings
	local default_config = {
		capabilities = capabilities,
		root_dir = function()
			return vim.loop.cwd()
		end,
		flags = {
			debounce_text_changes = 150,
		},
	}

	-- List of servers to install and configure
	local servers = {
		-- Simple servers (using default config)
		"lua_ls",
		"vtsls",
		"bashls",
		"emmet_language_server",
		"html",

		-- Servers with custom configs and the servers you don't want to install via mason
		["ruby_lsp"] = {},
        ["ocamllsp"] = {},
		["clangd"] = {
			filetypes = { "c", "cpp" },
			cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--header-insertion=iwyu",
				"--completion-style=detailed",
			},
		},
		["sourcekit"] = {
			filetypes = { "swift", "objc", "objcpp" },
		},
		["rust_analyzer"] = {
			settings = {
				["rust-analyzer"] = {
					checkOnSave = {
						command = "clippy",
					},
				},
			},
		},
		["basedpyright"] = {
			settings = {
				python = {
					analysis = {
						diagnosticSeverityOverrides = {
							reportUnusedImport = "none",
						},
						typeCheckingMode = "off", -- Completely disable type checking
					},
				},
				pyright = {
					disableOrganizeImports = true,
				},
			},
		},
		["gopls"] = {
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
				},
			},
		},
	}

	-- Setup servers
	for server, config in pairs(servers) do
		if type(server) == "number" then
			-- Simple server without custom config
			local server_name = config -- In this case, config is actually the server name
			lspconfig[server_name].setup(default_config)
		else
			-- Server with custom config
			local server_config = vim.tbl_deep_extend("force", default_config, config or {})
			lspconfig[server].setup(server_config)
		end
	end

	-- LSP attach configuration
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
		callback = function(ev)
			local bufnr = ev.buf
			local client = vim.lsp.get_client_by_id(ev.data.client_id)

			-- Enable completion
			vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

			-- Buffer local mappings
			local function buf_map(keys, func, desc, mode)
				mode = mode or "n"
				vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
			end

			buf_map("[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Go to previous diagnostic")
			buf_map("]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", "Go to next diagnostic")
			buf_map("gl", "<cmd>lua vim.diagnostic.open_float()<cr>", "Show diagnostic in float")
			buf_map("<space>ld", "<cmd>lua vim.diagnostic.setloclist()<cr>", "Add diagnostics to location list")
			buf_map("K", "<cmd>lua vim.lsp.buf.hover()<cr>", "[H]over [D]ocumentation")
			buf_map("gd", require("fzf-lua").lsp_definitions, "[G]oto [D]efinition")
			buf_map("gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", "[G]oto [D]eclaration")
			buf_map("gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", "[G]oto [I]mplementation")
			buf_map("go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", "[G]oto [T]ype [D]efinition")
			buf_map("gr", "<cmd>lua vim.lsp.buf.references()<cr>", "[G]oto [R]eferences")
			buf_map("<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", "[S]ignature [H]elp", { "n", "i" })
			buf_map("<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", "[R]e[N]ame")
			buf_map("<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", "[C]ode[A]ction", { "n", "x" })
			buf_map("<leader>ws", "<cmd>lua vim.lsp.buf.workspace_symbol()<cr>", "[C]ode[A]ction")
			buf_map("<leader>ds", "<cmd>lua vim.lsp.buf.document_symbol()<cr>", "[C]ode[A]ction")

			-- Formatting
			-- buf_map("<space>lf", function()
			-- 	vim.lsp.buf.format({ async = true })
			-- end, "Format")
			-- Document highlight
			if client and client.server_capabilities.documentHighlightProvider then
				local group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = false })
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					group = group,
					buffer = bufnr,
					callback = vim.lsp.buf.document_highlight,
				})
				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					group = group,
					buffer = bufnr,
					callback = vim.lsp.buf.clear_references,
				})
				vim.api.nvim_create_autocmd("LspDetach", {
					group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
					callback = function(event2)
						vim.lsp.buf.clear_references()
						vim.api.nvim_clear_autocmds({ group = "LspDocumentHighlight", buffer = event2.buf })
					end,
				})
			end
		end,
	})

	-- Mason setup
	require("mason").setup({
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	})
	require("mason-lspconfig").setup({
		ensure_installed = servers;
		automatic_installation = true,
	})

	require("mason-tool-installer").setup({
		ensure_installed = {
			"stylua",
			"shellcheck",
			"shfmt",
			"prettierd",
			"golangci-lint",
			"delve",
			"black",
		},
	})
end

return M
