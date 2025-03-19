{ inputs, pkgs, config, ... }: {

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
    jetbrains-mono

    vscodium
    vesktop
    zenith
    wofi
  ];

  programs = {
    firefox.enable = true;
    home-manager.enable = true;

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

  home = {
    username = "kaupec1";
    homeDirectory = "/home/kaupec1";
    stateVersion = "24.11";

    file = {
      ".config/sway" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/kaupec1/.dotfiles/config/sway";
        recursive = true;
      };
      ".config/ags" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/kaupec1/.dotfiles/config/ags";
        recursive = true;
      };
    };

    sessionVariables = {
  
    };
  };

}
