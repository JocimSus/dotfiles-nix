{
  inputs,
  pkgs,
  ...
}: {

  imports = [ inputs.ags.homeManagerModules.default ];

  home.username = "jocim-nix";
  home.homeDirectory = "/home/jocim-nix";

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home.packages = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    vesktop

    ## AGS ##
    # Astal CLI: `astal --help`
    inputs.ags.packages.${pkgs.system}.io

    # Astal Battery CLI: `astal-battery --help`
    inputs.ags.packages.${pkgs.system}.battery

    # Astal Hyprland CLI: `astal-hyprland --help`
    inputs.ags.packages.${pkgs.system}.hyprland
  ];

  programs = {
    firefox.enable = true;
      ags = {
      enable = true;

      # symlink to ~/.config/ags
      configDir = ./config/ags;

      # additional packages to add to gjs's runtime
      extraPackages = with inputs.ags.packages.${pkgs.system}; [
        io
        astal3
        apps
        auth
        battery
        bluetooth
        cava
        greet
        hyprland
        mpris
        network
        notifd
        powerprofiles
        river
        tray
        wireplumber
      ];
    };

  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jocim-nix/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
