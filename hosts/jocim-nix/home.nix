{
  inputs,
  pkgs,
  config,
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

  home.packages = with pkgs; [
    ## AGS ##
    inputs.ags.packages.${pkgs.system}.io
    inputs.ags.packages.${pkgs.system}.astal3
    inputs.ags.packages.${pkgs.system}.apps
    inputs.ags.packages.${pkgs.system}.auth
    inputs.ags.packages.${pkgs.system}.battery
    inputs.ags.packages.${pkgs.system}.bluetooth
    inputs.ags.packages.${pkgs.system}.cava
    inputs.ags.packages.${pkgs.system}.greet
    inputs.ags.packages.${pkgs.system}.hyprland
    inputs.ags.packages.${pkgs.system}.mpris
    inputs.ags.packages.${pkgs.system}.network
    inputs.ags.packages.${pkgs.system}.notifd
    inputs.ags.packages.${pkgs.system}.powerprofiles
    inputs.ags.packages.${pkgs.system}.river
    inputs.ags.packages.${pkgs.system}.tray
    inputs.ags.packages.${pkgs.system}.wireplumber
  ];

  programs = {
    home-manager.enable = true;
    firefox.enable = true;
    ags = {
      enable = true;

      extraPackages = with pkgs; [
        inputs.ags.packages.${pkgs.system}.io
        inputs.ags.packages.${pkgs.system}.astal3
        inputs.ags.packages.${pkgs.system}.apps
        inputs.ags.packages.${pkgs.system}.auth
        inputs.ags.packages.${pkgs.system}.battery
        inputs.ags.packages.${pkgs.system}.bluetooth
        inputs.ags.packages.${pkgs.system}.cava
        inputs.ags.packages.${pkgs.system}.greet
        inputs.ags.packages.${pkgs.system}.hyprland
        inputs.ags.packages.${pkgs.system}.mpris
        inputs.ags.packages.${pkgs.system}.network
        inputs.ags.packages.${pkgs.system}.notifd
        inputs.ags.packages.${pkgs.system}.powerprofiles
        inputs.ags.packages.${pkgs.system}.river
        inputs.ags.packages.${pkgs.system}.tray
        inputs.ags.packages.${pkgs.system}.wireplumber
        fzf
        gtksourceview
        webkitgtk
        accountsservice
        gtk-session-lock
      ];
    };
  };

  ## Home ##
  home = {
    username = "jocim-nix";
    homeDirectory = "/home/jocim-nix";
    stateVersion = "24.11"; # Do not change

    file = {
      ".config/ags" = {
#       how to make this use relative paths
        source = config.lib.file.mkOutOfStoreSymlink "/home/jocim-nix/.dotfiles/config/ags";
        recursive = true;
      };
      ".local/share/icons" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/jocim-nix/.dotfiles/local/share/icons";
        recursive = true;
      };
    };

    sessionVariables = {

    };
  };

}
