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
    extraGroups = [ "networkmanager" "wheel" "video" "msi" "libvirtd" "docker" ];
  };

  users.defaultUserShell = pkgs.zsh;

  ## Programs ##
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;
  programs.zsh.enable = true;
  programs.virt-manager.enable = true;

  programs.obs-studio = {
    enable = true;

    package = (
      pkgs.obs-studio.override {
        cudaSupport = true;
      }
    );

    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
    ];
  };

  # campus wifi does not allow port 22
  programs.ssh.extraConfig = ''
    Host github.com
      Hostname ssh.github.com
      Port 443
      User git
  '';

  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-qt5-1.1.05"
  ];

  environment.systemPackages = with pkgs; [
    ## Low Level ##
    efibootmgr
    gparted
    ventoy-full-qt
    popsicle

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
    speedtest-cli

    jdk17
    (python312.withPackages (ps: with ps; [ 
      pip
      flask
      pyyaml
      tkinter
    ]))
    nix-prefetch-git
    android-tools
    bun

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
    
    qdirstat
    zoom-us

    # KDE
    kdePackages.filelight
    kdePackages.kcalc
    guvcview
    fluffychat
    gnome-tweaks
    davinci-resolve
    google-chrome
    nextcloud-client
    obsidian

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
    bottles
    mangohud
    protonup
  ];

  nix.settings = {
    substituters = [
      "https://prismlauncher.cachix.org"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://jocimsus.cachix.org"
    ];
    trusted-substituters = [ 
      "https://prismlauncher.cachix.org"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://jocimsus.cachix.org"
    ];
     trusted-public-keys = [ 
      "prismlauncher.cachix.org-1:9/n/FGyABA2jLUVfY+DEp4hKds/rwO+SCOtbOkDzd+c=" 
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "jocimsus.cachix.org-1:JLglEO54KxFNzvLZlz6MxvYap/7gJLK0w+jT8GRHrXw="
    ];
  };
  
}
