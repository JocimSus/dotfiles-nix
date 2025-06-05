{
  inputs,
  pkgs,
  config,
  system,
  ...
}: {

  imports = [
    inputs.ags.homeManagerModules.default
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home.packages = [
    inputs.prismlauncher
  ];

  xdg.desktopEntries.prismlauncher = {
    name = "Prism Launcher";
    exec = "nvidia-offload ${inputs.prismlauncher.packages.${system}.prismlauncher}/bin/prismlauncher";
    icon = "${inputs.prismlauncher.packages.${system}.prismlauncher}/share/icons/hicolor/scalable/apps/org.prismlauncher.PrismLauncher.svg";
    terminal = false;
    categories = [ "Game" ];
  };

  programs = {
    home-manager.enable = true;
    firefox.enable = true;
    ags = {
      enable = true;

      extraPackages = with pkgs; [
        fzf
        gtksourceview
        webkitgtk
        accountsservice
        gtk-session-lock
      ];
    };
    kitty = {
      enable = true;
      settings = {
        confirm_os_window_close = 0; 
      };
    };
    tmux = {
      enable = true;
      keyMode = "vi";
      baseIndex = 1;
    };
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      # initContent = ''
      #   if [[ -z "$TMUX" ]] && [[ -n "$PS1" ]]; then
      #     exec tmux
      #   fi
      # '';
    };
    oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      settings = builtins.fromTOML (builtins.readFile ../../.config/ohmyposh/jocims.omp.toml);
      # useTheme = "easy-term"; # https://ohmyposh.dev/docs/themes
    };
  };

  ## Home ##
  home = {
    username = "jocim-nix";
    homeDirectory = "/home/jocim-nix";
    stateVersion = "24.11"; # Do not change

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

  ## systemd ##
  systemd.user.services.mute_led = {
    Unit = {
      Description = "Sync mute key state to your LED";
      Wants       = [ "sound.target" ];
      After       = [ "sound.target" ];
    };
    
    Service = {
      Type        = "simple";
      ExecStart   = "/run/current-system/sw/bin/python3 ${config.home.homeDirectory}/.dotfiles/hosts/jocim-nix/msi-shit/mute.py";
      Restart     = "on-failure";
    };
    
    Install = {
      WantedBy    = [ "default.target" ];
    };
  };

    systemd.user.services.mic_mute_led = {
    Unit = {
      Description = "Sync mic mute key state to your LED";
      Wants       = [ "sound.target" ];
      After       = [ "sound.target" ];
    };
    
    Service = {
      Type        = "simple";
      ExecStart   = "/run/current-system/sw/bin/python3 ${config.home.homeDirectory}/.dotfiles/hosts/jocim-nix/msi-shit/mic_mute.py";
      Restart     = "on-failure";
    };
    
    Install = {
      WantedBy    = [ "default.target" ];
    };
  };

}
