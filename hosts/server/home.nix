{
  config,
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
      '';
      shellAliases = {
        ssh = "ssh -i ${config.home.homeDirectory}/.ssh/woof";
        c = "clear";
        cdd = "cd ~/.dotfiles";
      };
    };
    oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      # because i needed to use --config on omp, was forced to do it like this
      settings = builtins.fromTOML (builtins.readFile .config/ohmyposh/jocims.omp.toml);
      # useTheme = "easy-term"; # https://ohmyposh.dev/docs/themes
    };
    neovim =
      let
        fromFile = f: "${builtins.readFile f}";
        treesitter-parsers = pkgs.symlinkJoin {
          name = "treesitter-parsers";
          paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
        };
      in
      {
        enable = true;

        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;

        extraLuaConfig = ''
          ${builtins.readFile .config/nvim/options.lua}
          ${builtins.readFile .config/nvim/plugins/treesitter.lua}
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
          mini-icons
          nvim-web-devicons
          luasnip
          friendly-snippets
          cmp-nvim-lsp
          cmp_luasnip
          nvim-treesitter.withAllGrammars
          nvim-dap
          nvim-dap-python
          nvim-dap-virtual-text
          nvim-nio
          plenary-nvim
          nvim-jdtls
          neotest-java
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
          {
            plugin = comment-nvim;
            type = "lua";
            config = fromFile .config/nvim/plugins/comments.lua;
          }
          {
            plugin = catppuccin-nvim;
            config = "colorscheme catppuccin-mocha";
          }
          {
            plugin = lualine-nvim;
            type = "lua";
            config = fromFile .config/nvim/plugins/lualine.lua;
          }
          {
            plugin = nvim-cmp;
            type = "lua";
            config = fromFile .config/nvim/plugins/cmp.lua;
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
            plugin = nvim-dap;
            type = "lua";
            config = fromFile .config/nvim/plugins/dap.lua;
          }
          {
            plugin = nvim-dap-ui;
            type = "lua";
            config = "require('dapui').setup()";
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
          {
            plugin = neotest;
            type = "lua";
            config = fromFile .config/nvim/plugins/neotest.lua;
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
