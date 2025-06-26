{
  pkgs,
  inputs,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
      ./system.nix
      ./services/system
    ];

  users.groups.msi= {};

  networking.hostName = "meow";
  users.users.jocim-nix = {
    isNormalUser = true;
    description = "jocim-nix";
    extraGroups = [ "networkmanager" "wheel" "video" "msi" "libvirtd" ];
  };

  users.defaultUserShell = pkgs.zsh;

  ## Programs ##
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;
  programs.zsh.enable = true;
  programs.virt-manager.enable = true;

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
    pulseaudio

    ## Terminal  ##
    unrar
    unzip
    p7zip

    yt-dlp
    ffmpeg-full
    aria2
    jq
    wl-clipboard

    jdk17
    (python312.withPackages (ps: with ps; [ 
      pip
      flask
      pyyaml
    ]))
    nix-prefetch-git
    android-tools

    btop-cuda
    lunarvim
    vscode
    cloudflared

    git
    gnumake
    cargo
    nodejs_24
    ripgrep
    lazygit

    ## Desktop Apps ##
    # Essentials
    qbittorrent
    vesktop
    inputs.zen-browser.packages.${pkgs.system}.default # you can do pkgs.system?!?!
    vlc
    
    (pkgs.obs-studio.override { cudaSupport = true; })
    qdirstat
    zoom-us

    # KDE
    kdePackages.filelight
    kdePackages.kcalc
    guvcview

    # Printing
    kdePackages.print-manager
    system-config-printer
    cups

    # Documents and Books
    calibre
    onlyoffice-desktopeditors

    ## Gaming ##
    protontricks
    vulkan-tools
    lutris
    mangohud
    protonup
  ];

  nix.settings = {
    trusted-public-keys = [ 
      "prismlauncher.cachix.org-1:9/n/FGyABA2jLUVfY+DEp4hKds/rwO+SCOtbOkDzd+c=" 
    ];
    trusted-substituters = [ 
      "https://prismlauncher.cachix.org"
    ];
  };
  
}
