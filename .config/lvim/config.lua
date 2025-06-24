-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

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

lvim.builtin.treesitter.highlight.disable = { "c" }

lvim.keys.normal_mode["gt"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["gT"] = ":BufferLineCyclePrev<CR>"


