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

  ];

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
  };

  ## Home ##
  home = {
    username = "jocim-nix";
    homeDirectory = "/home/jocim-nix";
    stateVersion = "24.11"; # Do not change

    file = {
      ".config/ags" = {
#       how to make this use relative paths
        source = config.lib.file.mkOutOfStoreSymlink "/home/jocim-nix/.dotfiles/.config/ags";
        recursive = true;
      };
      # ".config/nvfancontrol.conf" = {
      #   source = config.lib.file.mkOutOfStoreSymlink "/home/jocim-nix/.dotfiles/.config/nvfancontrol.conf";
      # };
      ".local/share/icons" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/jocim-nix/.dotfiles/.local/share/icons";
        recursive = true;
      };
    };

    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/jocim-nix/.steam/root/compatibilitytools.d";
    };
  };

}
