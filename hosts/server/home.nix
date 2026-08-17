# Home-Manager entry point.
{
  pkgs,
  lib,
  ...
}:
{
  home.packages = [

  ];

  programs = {
    home-manager.enable = true;
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      initContent = lib.mkAfter ''
        bindkey "^[[1;5D" backward-word
        bindkey "^[[1;5C" forward-word

        export EDITOR="nvim"
      '';
      shellAliases = {
        c = "clear";
        cdd = "cd ~/.dotfiles";
      };
    };
    oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      settings = fromTOML (builtins.readFile .config/ohmyposh/jocims.omp.toml);
    };
    neovim =
      let
        fromFile = f: "${builtins.readFile f}";
      in
      {
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
          xclip
          wl-clipboard

          gcc
          file
          lua-language-server
          clang-tools
          pyright
          nixd
          nil
          jdt-language-server
          gradle

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
  };

  home = {
    username = "jocim-server";
    homeDirectory = "/home/jocim-server";
    stateVersion = "25.05"; # Do not change

    shellAliases = { };

    file = { };
  };
}
