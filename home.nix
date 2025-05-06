{ inputs, pkgs, config, ... }: {

  imports = [
    
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home.packages = with pkgs; [
    jetbrains-mono
    fastfetchMinimal
    vscodium
    vesktop
    zenith
    wofi

    zenity
    xdg-desktop-portal

    prismlauncher

    gamemode
    winetricks
    inputs.nix-gaming.packages.${pkgs.system}.osu-stable
    opentabletdriver
  ];

  programs = {
    firefox = {
      enable = true;
    };
    home-manager.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
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
    };

    sessionVariables = {
  
    };
  };

}
