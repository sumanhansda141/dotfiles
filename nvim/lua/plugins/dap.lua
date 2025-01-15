local M = {
	"mfussenegger/nvim-dap",
	dependencies = {
		"leoluz/nvim-dap-go",
		"mfussenegger/nvim-dap-python",
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-neotest/nvim-nio",
	},
}

function M.config()
	local dap = require("dap")
	local ui = require("dapui")

	require("dapui").setup()
	require("dap-go").setup()
	require("dap-python").setup(vim.g.python_host_prog)
	require("dap-python").test_runner = "pytest"

	dap.adapters.cppdbg = {
		id = "cppdbg",
		type = "executable",
		command = vim.fn.stdpath("data") .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
	}
	dap.configurations.cpp = {
		{
			name = "Launch file",
			type = "cppdbg",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopAtEntry = true,
		},
		{
			name = "Attach to gdbserver :1234",
			type = "cppdbg",
			request = "launch",
			MIMode = "gdb",
			miDebuggerServerAddress = "localhost:1234",
			miDebuggerPath = "/usr/bin/gdb",
			cwd = "${workspaceFolder}",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
		},
	}

	dap.configurations.c = dap.configurations.cpp
	dap.configurations.rust = dap.configurations.cpp

	-- DAP
	local keymap = vim.keymap.set
	keymap("n", "<leader>db", dap.toggle_breakpoint)
	keymap("n", "<leader>dS", dap.continue)
	keymap("n", "<leader>di", dap.step_into)
	keymap("n", "<leader>so", dap.step_over)
	keymap("n", "<leader>dO", dap.step_out)
	keymap("n", "<leader>dr", dap.repl.toggle)
	keymap("n", "<leader>dl", dap.run_last)
	keymap("n", "<leader>du", ui.toggle)
	keymap("n", "<leader>dt", dap.terminate)

	dap.listeners.before.attach.dapui_config = function()
		ui.open()
	end
	dap.listeners.before.launch.dapui_config = function()
		ui.open()
	end
	dap.listeners.before.event_terminated.dapui_config = function()
		ui.close()
	end
	dap.listeners.before.event_exited.dapui_config = function()
		ui.close()
	end
end

return M
