{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./services/home 
    inputs.ags.homeManagerModules.default
  ];

  ## Programs ##
  home.packages = [
    inputs.prismlauncher
  ];

  xdg.desktopEntries.prismlauncher = {
    name = "Prism Launcher";
    exec = "${inputs.prismlauncher.packages.${pkgs.system}.prismlauncher}/bin/prismlauncher";
    icon = "${inputs.prismlauncher.packages.${pkgs.system}.prismlauncher}/share/icons/hicolor/scalable/apps/org.prismlauncher.PrismLauncher.svg";
    terminal = false;
    categories = [ "Game" ];
  };

  programs = {
    home-manager.enable = true;
    firefox.enable = true;
    # ags = {
    #   enable = true;

    #   extraPackages = with pkgs; [
    #     fzf
    #     gtksourceview
    #     accountsservice
    #     gtk-session-lock
    #   ];
    # };
    kitty = {
      enable = true;
      settings = { # would rather use a .conf
        confirm_os_window_close = 0; 
      };
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
  };

  ## Home ##
  home = {
    username = "jocim-nix";
    homeDirectory = "/home/jocim-nix";
    stateVersion = "24.11"; # Do not change

    shellAliases = {
    };

    file = {
      ".config/ags" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/ags";
        recursive = true;
      };

      ".config/hypr" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/hypr";
        recursive = true;
      };

      ".config/lvim" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/lvim";
        recursive = true;
      };

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
