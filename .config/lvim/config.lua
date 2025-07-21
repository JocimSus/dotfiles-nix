-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-- Add Nix parsing
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

parser_config.nix = {
  install_info = {
    url = vim.fn.stdpath("config") .. "/tree-sitter-nix",
    files = { "src/parser.c" },
    generate_requires_npm = true,
    requires_generate_from_grammar = true,
  },
  filetype = "nix",
}

lvim.builtin.treesitter.ensure_installed = {
  "nix",
}

require("lvim.lsp.manager").setup("nil_ls", {
  settings = {
    nix = {
      flake = {
        autoArchive = true, -- removes prompt for flake inputs everytime you open *.nix
        autoEvalInputs = true, -- should have more options
      },
    },
  },
})

-- C language is broken, need to investigate
lvim.builtin.treesitter.highlight.disable = { "c" }


---
-- Keybinds
---
lvim.keys.normal_mode["gt"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["gT"] = ":BufferLineCyclePrev<CR>"

lvim.keys.normal_mode["j"] = "h"
lvim.keys.normal_mode["k"] = "j"
lvim.keys.normal_mode["l"] = "k"
lvim.keys.normal_mode[";"] = "l"

lvim.keys.visual_mode["j"] = "h"
lvim.keys.visual_mode["k"] = "j"
lvim.keys.visual_mode["l"] = "k"
lvim.keys.visual_mode[";"] = "l"

