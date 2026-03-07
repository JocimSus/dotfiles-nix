--
-- debug adaptor protocol
--

-- breakpoint icon
vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' })

-- keymaps
local bufmap = function(keys, func, desc)
  vim.keymap.set("n", keys, func, { noremap = true, silent = true, desc = desc })
end

bufmap("<leader>b", function() require('dap').toggle_breakpoint() end, "Toggle Breakpoint")
bufmap("<leader>q", function() require('dap').continue() end, "Continue Program")

-- nvim dap ui auto open
local dap, dapui = require("dap"), require("dapui")
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

-- nvim dap virtual text
require("nvim-dap-virtual-text").setup { virt_text_win_col = 80 }

-- nvim dap python
require("dap-python").setup("python")
