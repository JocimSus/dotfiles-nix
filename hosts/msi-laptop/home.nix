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
