# Entry point for Home-Manager MSI Laptop configuration
{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./neovim.nix
    ./msi-leds.nix
  ];

  ## Programs ##
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

        extraConfig = ''
          # Vim like keybindings
          bind h split-window -v
          bind v split-window -h

          bind -n C-h select-pane -L
          bind -n C-j select-pane -D
          bind -n C-k select-pane -U
          bind -n C-l select-pane -R

          # Kitty config
          set -as terminal-features ",xterm-kitty:24bit"

          # Colors from kitty.conf
          # Catppuccin Mocha Styling
          set -g status-style bg="#181825",fg="#cdd6f4"

          setw -g window-status-current-style bg="#cba6f7",fg="#11111b",bold
          setw -g window-status-current-format " #I:#W "

          setw -g window-status-style bg="#181825",fg="#585b70"
          setw -g window-status-format " #I:#W "

          set -g pane-border-style fg="#6c7086"       
          set -g pane-active-border-style fg="#b4befe"
        '';
      };
      zsh = {
        enable = true;
        autosuggestion.enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;

        # left arrow and right arrow can move per-word
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
    };

  ## Home ##
  home = {
    username = "jocim-nix";
    homeDirectory = "/home/jocim-nix";
    stateVersion = "24.11"; # Do not change
    shellAliases = { };
    file = { };
  };

  ## Nix settings ##
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };
}
