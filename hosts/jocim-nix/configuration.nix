{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
      ../common.nix
    ];

  swapDevices = [{
    device = "/swapfile";
    size = 16 * 1024;
  }];

  ## Graphics ##
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    # Currently using offload, need prime sync?
    # TODO: Forgor what this does
    powerManagement.finegrained = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";

        offload = {
            enable = true;
            enableOffloadCmd = true;
        };
      };
    };

  ## Desktop ##
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  # programs.hyprland = {
  #   enable = true;
  #   package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  #   portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  # };

  # Use cache instead of building from source
  nix.settings = {
    # Hyprland
    # substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = [ 
      # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" 
      "prismlauncher.cachix.org-1:9/n/FGyABA2jLUVfY+DEp4hKds/rwO+SCOtbOkDzd+c=" 
      ];

    # Prism Launcher
    trusted-substituters = [ "https://prismlauncher.cachix.org" ];
  };

  ## User account ##
  networking.hostName = "meow";
  users.users.jocim-nix = {
    isNormalUser = true;
    description = "jocim-nix";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  ## System programs ##
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  programs.gamemode.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  programs.obs-studio = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    ## Low Level ##
    efibootmgr

    ## Graphics ##
    intel-media-driver
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl

    ## Filesystem ##
    ntfs3g
    usbutils

    ## MSI ##
    mcontrolcenter

    ## Terminal  ##
    unrar
    unzip
    p7zip

    kitty
    
    git
    playerctl
    btop

    ## Desktop Apps ##
    vesktop
    vscode
    vlc
    qbittorrent
    distrobox
    qdirstat

    ## Gaming ##
    protontricks
    vulkan-tools
    lutris
    mangohud
    protonup
  ];

}
