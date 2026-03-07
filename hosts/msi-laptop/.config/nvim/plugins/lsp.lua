--
-- language server protocol
--

local on_attach = function(_, bufnr)
  local bufmap = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  bufmap("<leader>r", vim.lsp.buf.rename, "Rename variable")
  bufmap("<leader>a", vim.lsp.buf.code_action, "Code action")

  bufmap("gd", vim.lsp.buf.definition, "Go to definition")
  bufmap("gD", vim.lsp.buf.declaration, "Go to declaration")
  bufmap("gI", vim.lsp.buf.implementation, "Go to implementation")
  bufmap("<leader>D", vim.lsp.buf.type_definition, "Type definition")

  bufmap("gr", require('telescope.builtin').lsp_references, "Find references")
  bufmap("<leader>s", require('telescope.builtin').lsp_document_symbols, "Find document symbols")
  bufmap("<leader>S", require('telescope.builtin').lsp_dynamic_workspace_symbols, "Find dynamic workspace symbols")

  bufmap("K", vim.lsp.buf.hover, "Hover")
  bufmap("<leader>f", vim.lsp.buf.format, "Format code")
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
-- local lspconfig = require("lspconfig")

-- TODO: Setup mason for non-NixOS systems
-- require("mason").setup()
-- require("mason-lspconfig").setup({
--   ensure_installed = {},
--   automatic_enable = false,
--   automatic_installation = false,
-- })

-- nil_ls must be before nixd; nixd breaks <leader> key
local servers = { "lua_ls", "clangd", "pyright", "nil_ls", "nixd", "jdtls" }
local util = require("lspconfig.util")

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

  if server == "clangd" then
    local clangd_cmd = vim.fn.exepath("clangd")
    if clangd_cmd == "" then
      clangd_cmd = "/run/current-system/sw/bin/clangd"
    end

    opts.cmd = { clangd_cmd, "--background-index" }
    opts.init_options = {
      clangdFileStatus = true,
      completeUnimported = true,
      usePlaceholders = true,
    }
  end

  if server == "pyright" then
    opts.settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = 'openFilesOnly',
        },
      }
    }
  end

  if server == "nil_ls" then
    opts.settings = {
      ["nil"] = {
        nix = {
          flake = {
            autoArchive = true,
          },
        },
      },
    }
  end

  if server == "nixd" then
    opts.settings = {
      nixd = {
        nixpkgs = {
          expr = "import <nixpkgs> { }",
        },
        formatting = {
          command = { "nixfmt" },
        },
        options = {
          nixos = {
            expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.k-on.options',
          },
          home_manager = {
            expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."ruixi@k-on".options',
          },
        },
      },
    }
  end

  if server == "jdtls" then
    opts.settings = {
      java = {
        project = {
          referencedLibraries = {
            "lib/**/*.jar",
          },
        },
      },
    }
  end

  -- if server == "jdtls" then
  --   local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  --
  --   opts.cmd = {
  --     "jdtls",
  --     "-data",
  --     vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name
  --   }
  --
  --   opts.root_dir = util.root_pattern(
  --     "gradlew",
  --     "settings.gradle.kts",
  --     "build.gradle.kts",
  --     "pom.xml",
  --     ".git"
  --   )
  --
  --   opts.single_file_support = true
  -- end

  vim.lsp.config(server, opts)
  vim.lsp.enable(server)

  -- if lspconfig[server] then
  -- 	lspconfig[server].setup(opts)
  -- else
  -- 	vim.notify("lspconfig: no server module for", server, vim.log.levels.WARN)
  -- end
end
