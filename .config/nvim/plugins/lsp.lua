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

	bufmap("gr", require('telescope.builtin').lsp_references)
	bufmap("<leader>s", require('telescope.builtin').lsp_document_symbols)
	bufmap("<leader>S", require('telescope.builtin').lsp_dynamic_workspace_symbols)

	bufmap("K", vim.lsp.buf.hover)

	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, {})
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Inline Diagnostics --
vim.diagnostic.config({
  virtual_text = { spacing = 4, prefix = "●" },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = "󰠠 ",
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = "Error",
      [vim.diagnostic.severity.WARN] = "Warn",
      [vim.diagnostic.severity.INFO] = "Info",
      [vim.diagnostic.severity.HINT] = "Hint",
    },
	},
})

-- vim.api.nvim_create_autocmd("CursorHold", {
--   callback = function()
--     vim.diagnostic.open_float(nil, { focus = false, scope = "line" })
--   end,
-- })

---- Language Servers ----
local lspconfig = require("lspconfig")

-- TODO: Setup mason for non-NixOS systems
-- require("mason").setup()
-- require("mason-lspconfig").setup({
--   ensure_installed = {},
--   automatic_enable = false,
--   automatic_installation = false,
-- })

local servers = { "lua_ls" }

for _, server in ipairs(servers) do
  local opts = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  if server == "lua_ls" then
    opts.settings = {
      Lua = {
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
            "${pkgs.neovim-unwrapped}/share/nvim/runtime",
          },
        },
        telemetry = { enable = false },
        hover = {
          expandAlias = true,
          previewFields = true,
        },
      }
    }
  end

  if lspconfig[server] then
    lspconfig[server].setup(opts)
  else
    vim.notify("lspconfig: no server module for", server, vim.log.levels.WARN)
  end
end

