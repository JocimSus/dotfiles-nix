{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
{
  ## Programs ##
  xdg.desktopEntries.prismlauncher = {
    name = "Prism Launcher";
    exec = "${inputs.prismlauncher.packages.${pkgs.system}.prismlauncher}/bin/prismlauncher";
    icon = "${
      inputs.prismlauncher.packages.${pkgs.system}.prismlauncher
    }/share/icons/hicolor/scalable/apps/org.prismlauncher.PrismLauncher.svg";
    terminal = false;
    categories = [ "Game" ];
  };

  programs =
    let
      shellAliases = {
        c = "clear";
        cdd = "cd ~/.dotfiles";
        cdc = "cd ~/College";
      };
    in
    {
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
        tmuxp.enable = true;
      };
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
        shellAliases = shellAliases;
      };
      bash = {
        enable = true;
        enableCompletion = true;
        shellAliases = shellAliases;
      };
      oh-my-posh = {
        enable = true;
        enableZshIntegration = true;
        settings = fromTOML (builtins.readFile .config/ohmyposh/jocims.omp.toml);
      };
      gradle = {
        enable = true;
        package = pkgs.gradle_9;
      };
      neovim =
        let
          fromFile = f: "${builtins.readFile f}";
        in
        {
          enable = true;

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

  ## Home ##
  home = {
    username = "jocim-nix";
    homeDirectory = "/home/jocim-nix";
    stateVersion = "24.11"; # Do not change

    shellAliases = { };

    file = {
      ".local/share/icons/" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hosts/msi-laptop/.local/share/icons/";
        recursive = false;
      };
    };

    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${config.home.homeDirectory}/.steam/root/compatibilitytools.d";
    };
  };

  ## Systemd user services ##
  systemd.user.services.mute_led = {
    Unit = {
      Description = "Sync mute key state to your LED";
      Wants = [ "sound.target" ];
      After = [ "sound.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "/run/current-system/sw/bin/python3 ${config.home.homeDirectory}/.dotfiles/scripts/msi/mute.py";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  systemd.user.services.mic_mute_led = {
    Unit = {
      Description = "Sync mic mute key state to your LED";
      Wants = [ "sound.target" ];
      After = [ "sound.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "/run/current-system/sw/bin/python3 ${config.home.homeDirectory}/.dotfiles/scripts/msi/mic_mute.py";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  ## Nix settings ##
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };
}
