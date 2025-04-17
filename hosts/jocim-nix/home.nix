{
  inputs,
  pkgs,
  config,
  ...
}: 
let
  system = "x86_64-linux";
in {

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
      # ".config/nvfancontrol.conf" = {
      #   source = config.lib.file.mkOutOfStoreSymlink "/home/jocim-nix/.dotfiles/.config/nvfancontrol.conf";
      # };
      ".local/share/icons" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.local/share/icons";
        recursive = true;
      };
    };

    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/jocim-nix/.steam/root/compatibilitytools.d";
    };
  };

}
