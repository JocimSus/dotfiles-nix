{
  pkgs,
  ...
}:
let
  fromFile = f: "${builtins.readFile f}";
in
{
  programs.neovim = {
    enable = true;

    withRuby = true;
    withPython3 = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    initLua = ''
      ${fromFile .config/nvim/options.lua}
      ${fromFile .config/nvim/plugins/treesitter.lua}
    '';

    extraPackages = with pkgs; [
      # Misc Packages
      xclip
      wl-clipboard
      gcc
      file

      # Language Servers
      lua-language-server
      clang-tools
      pyright
      nixd
      nil
      jdt-language-server
      gradle
      golangci-lint-langserver
      gopls

      # Go Development
      go
      gotools
      gomodifytags
      golangci-lint
      iferr
      impl

      # Formatting tools
      nixfmt
    ];

    plugins = with pkgs.vimPlugins; [
      # Language Server
      nvim-jdtls
      go-nvim
      {
        plugin = neodev-nvim;
        type = "lua";
        config = fromFile .config/nvim/plugins/neodev.lua;
      }
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = fromFile .config/nvim/plugins/lsp.lua;
      }

      # DAP
      nvim-dap
      nvim-dap-python
      nvim-dap-virtual-text
      {
        plugin = nvim-dap;
        type = "lua";
        config = fromFile .config/nvim/plugins/dap.lua;
      }
      {
        plugin = nvim-dap-ui;
        type = "lua";
        config = "require('dapui').setup()";
      }

      # CMP
      cmp-nvim-lsp
      cmp_luasnip
      {
        plugin = nvim-cmp;
        type = "lua";
        config = fromFile .config/nvim/plugins/cmp.lua;
      }

      # Testing
      neotest-java
      {
        plugin = neotest;
        type = "lua";
        config = fromFile .config/nvim/plugins/neotest.lua;
      }

      # QOL & Themes
      mini-icons
      nvim-web-devicons
      friendly-snippets
      plenary-nvim
      nvim-treesitter.withAllGrammars
      nvim-nio
      luasnip
      {
        plugin = comment-nvim;
        type = "lua";
        config = fromFile .config/nvim/plugins/comments.lua;
      }
      {
        plugin = catppuccin-nvim;
        type = "viml";
        config = "colorscheme catppuccin-mocha";
      }
      {
        plugin = lualine-nvim;
        type = "lua";
        config = fromFile .config/nvim/plugins/lualine.lua;
      }
      {
        plugin = telescope-fzf-native-nvim;
        type = "lua";
        config = fromFile .config/nvim/plugins/telescope.lua;
      }
      {
        plugin = nvim-autopairs;
        type = "lua";
        config = "require('nvim-autopairs').setup()";
      }
      {
        plugin = render-markdown-nvim;
        type = "lua";
        config = "require('render-markdown').setup({})";
      }
      {
        plugin = mini-icons;
        type = "lua";
        config = "require('mini.icons').setup()";
      }
      {
        plugin = which-key-nvim;
        type = "lua";
        config = fromFile .config/nvim/plugins/which-key.lua;
      }
    ];
  };
}
