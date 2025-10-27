{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./services/home
  ];

  ## Programs ##
  home.packages = [
    inputs.prismlauncher
  ];

  xdg.desktopEntries.prismlauncher = {
    name = "Prism Launcher";
    exec = "${inputs.prismlauncher.packages.${pkgs.system}.prismlauncher}/bin/prismlauncher";
    icon = "${
      inputs.prismlauncher.packages.${pkgs.system}.prismlauncher
    }/share/icons/hicolor/scalable/apps/org.prismlauncher.PrismLauncher.svg";
    terminal = false;
    categories = [ "Game" ];
  };

  programs = {
    home-manager.enable = true;
    kitty = {
      enable = true;
      extraConfig = lib.readFile .config/kitty/kitty.conf;
    };
    tmux = {
      enable = true;
      keyMode = "vi";
      mouse = true;
      baseIndex = 1;
      escapeTime = 10;
      focusEvents = true;
      terminal = "screen-256color";
    };
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
        ssh = "ssh -i ${config.home.homeDirectory}/.ssh/meow";
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
          paths = (pkgs.vimPlugins.nvim-treesitter.withAllGrammars).dependencies;
        };
      in
      {
        enable = true;

        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;

        extraLuaConfig = ''
          vim.opt.runtimepath:append("${treesitter-parsers}")
          ${builtins.readFile .config/nvim/options.lua}
          ${builtins.readFile .config/nvim/plugins/treesitter.lua}
        '';

        extraPackages = with pkgs; [
          xclip
          wl-clipboard

          gcc
          lua-language-server
          clang-tools
          pyright
          nixd
          nil
          nixfmt-rfc-style
        ];

        plugins = with pkgs.vimPlugins; [
          nvim-web-devicons
          luasnip
          friendly-snippets
          cmp-nvim-lsp
          cmp_luasnip
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
            config = "require('Comment').setup()";
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
          nvim-treesitter.withAllGrammars
        ];
      };
  };

  ## Home ##
  home = {
    username = "jocim-nix";
    homeDirectory = "/home/jocim-nix";
    stateVersion = "24.11"; # Do not change

    shellAliases = {
    };

    file = {
      ".local/share/icons" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.local/share/icons";
        recursive = true;
      };
    };

    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${config.home.homeDirectory}/.steam/root/compatibilitytools.d";
    };
  };

  ## Nix settings ##
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };
}
