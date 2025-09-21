--
-- language server protocol
--

local on_attach = function(_, bufnr)
	local bufmap = function(keys, func)
		vim.keymap.set("n", keys, func, { buffer = bufnr })
	end

	bufmap("<leader>r", vim.lsp.buf.rename)
	bufmap("<leader>a", vim.lsp.buf.code_action)

	bufmap("gd", vim.lsp.buf.definition)
	bufmap("gD", vim.lsp.buf.declaration)
	bufmap("gI", vim.lsp.buf.implementation)
	bufmap("<leader>D", vim.lsp.buf.type_definition)

	-- bufmap("gr", require('telescope.builtin').lsp_references)
	-- bufmap("<leader>s", require('telescope.builtin').lsp_document_symbols)
	-- bufmap("<leader>S", require('telescope.builtin').lsp_dynamic_workspace_symbols)

	bufmap("K", vim.lsp.buf.hover)

	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, {})
end

local capabilities = vim.lsp.protocol.make_client_capabilities()


-- Inline Diagnostics --
vim.diagnostic.config({
  virtual_text = { spacing = 4, prefix = "●" },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.fn.sign_define("DiagnosticSignError", { text = "✖", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn",  { text = "⚠", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo",  { text = "ℹ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint",  { text = "➤", texthl = "DiagnosticSignHint" })

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false, scope = "line" })
  end,
})

---- Language Servers ----
local lspconfig = require("lspconfig")

-- Lua LSP --
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {},
  automatic_enable = false,
})

lspconfig.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  Lua = {
    workspace = { checkThirdParty = false },
    telemetry = { enable = false },
  }
}

