{ 
  config, 
  ... 
}: {
  home.packages = [

  ];

  programs = {
    home-manager.enable = true;
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ssh = "ssh -i ${config.home.homeDirectory}/.ssh/woof"; 
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

  home = {
    username = "jocim-server";
    homeDirectory = "/home/jocim-server";
    stateVersion = "25.05"; # Do not change

    shellAliases = {
    };

    file = {
    };
  };
}
