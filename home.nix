{ inputs, pkgs, config, ... }: {

  imports = [  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home.packages = with pkgs; [
    vscodium
    vesktop
    eww
    zenith
  ];

  programs = {
    firefox.enable = true;
    home-manager.enable = true;

    kitty = {
      enable = true;
      extraConfig = ''
        map ctrl+backspace send_text \x17
      '';
    };

    #eww.enable = true;

    #ags = {
    #  enable = true;

    #  extraPackages = with inputs.ags.packages.${pkgs.system}; [
    #   io
    #    astal3
    #    apps
    #    auth
    #    battery
    #    bluetooth
    #    cava
    #    greet
    #    mpris
    #    network
    #    notifd
    #    powerprofiles
    #    river
    #    tray
    #    wireplumber
    #  ];
    #};
  };

  home = {
    username = "kaupec1";
    homeDirectory = "/home/kaupec1";
    stateVersion = "24.11";

    file = {
      ".config/eww" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/kaupec1/.dotfiles/config/eww";
        recursive = true;
      };
    };

    sessionVariables = {
  
    };
  };

}
