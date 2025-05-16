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

  # Check nixos.wiki for NVIDIA
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;

    # Finegrained turns off GPU when not in use.
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
  programs.hyprland.enable = true;

  # Use cache instead of building from source
  nix.settings = {
    trusted-public-keys = [ 
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
  services.flatpak.enable = true;
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  # virtualisation.podman = {
  #   enable = true;
  #   dockerCompat = true;
  # };

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
    yt-dlp
    ffmpeg
    aria2

    kitty
    
    git
    btop

    ## Desktop Apps ##
    vesktop
    vscode
    vlc
    qbittorrent
    qdirstat
    snapshot
    zoom-us
    kdePackages.filelight
    kdePackages.kcalc

    libreoffice-qt6-fresh
    wpsoffice

    ## Gaming ##
    protontricks
    vulkan-tools
    lutris
    mangohud
    protonup
  ];

}
