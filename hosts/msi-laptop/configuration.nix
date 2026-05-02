{
  pkgs,
  pkgs-25_05,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./system.nix

    # Modules
    ../../modules/hardware/audio
    ../../modules/hardware/bluetooth
    ../../modules/hardware/gamepad
    ../../modules/hardware/nvidia

    ../../modules/system/locales
    ../../modules/system/sops
    ../../modules/system/virtualisation
    ../../modules/system/waydroid

    ../../modules/services/tailscale
    ../../modules/services/flatpak
    ../../modules/services/printing
  ];

  ## Sops-nix ##
  sops = {
    defaultSopsFile = ../../secrets/msi-laptop/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/jocim-nix/.config/sops/age/keys.txt";
  };

  ## User Configuration ##
  users.groups.msi = { };
  virtualisation.docker.enable = true;

  networking.hostName = "meow";
  users.users.jocim-nix = {
    isNormalUser = true;
    description = "jocim-nix";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "msi"
      "libvirtd"
      "docker"
    ];
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
    enableVirtualCamera = true;

    package = pkgs.obs-studio.override {
      cudaSupport = true;
    };

    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
    ];
  };

  programs.ssh.extraConfig = ''
    Host github.com
    HostName ssh.github.com
    Port 443
    User git
    IdentityFile ~/.ssh/meow

    Host server-tail
    HostName 100.100.110.110
    User jocim-server
    IdentityFile ~/.ssh/meow

    Host server
    Hostname 192.168.1.100
    User jocim-server
    IdentityFile ~/.ssh/meow

    Host greg
    HostName 100.65.230.109
    User r
    IdentityFile ~/.ssh/meow
  '';

  nixpkgs.config.permittedInsecurePackages = [
    # "ventoy-qt5-1.1.10"
  ];

  ## Services ##
  services.cloudflare-warp.enable = true;

  ## Fonts ##
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    nerd-fonts.fantasque-sans-mono
  ];

  ## Packages ##
  environment.systemPackages = with pkgs; [
    ## Low Level ##
    efibootmgr
    clang-tools
    man-pages
    file
    gcc
    gdb

    ## Graphics ##
    intel-media-driver
    intel-vaapi-driver
    libva-vdpau-driver
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
    tree
    sops
    yt-dlp
    aria2
    ffmpeg-full
    jq
    nixfmt
    wl-clipboard
    imagemagick

    (python314.withPackages (
      ps: with ps; [
        pip
        flask
        pyyaml
        tkinter
        debugpy # nvim python debugging plugin
      ]
    ))
    (jdk17.override {
      enableJavaFX = true;
    })
    jdt-language-server
    postgresql
    android-tools
    nodejs_24
    gnumake
    go

    git
    pnpm
    bun
    wine

    btop-cuda
    cloudflared
    opencode

    ## Desktop Apps ##
    # Essentials
    qbittorrent
    vesktop
    inputs.zen-browser.packages.${pkgs.system}.default
    vlc

    qdirstat

    # KDE
    kdePackages.filelight
    kdePackages.kcalc

    # Apps
    gnome-tweaks
    google-chrome
    nextcloud-client
    pkgs-25_05.obsidian
    postman
    logisim-evolution
    mars-mips
    vscode
    zoom-us

    gparted
    ghidra-bin
    # ventoy-full-qt

    # Printing
    kdePackages.print-manager
    system-config-printer
    cups

    # Documents and Books
    calibre
    libreoffice-qt
    hunspell
    hunspellDicts.en_US-large
    hunspellDicts.en_GB-large
    hunspellDicts.id_ID
    hyphenDicts.all
    xournalpp

    ## Gaming ##
    protontricks
    vulkan-tools
    lutris
    mangohud
    protonup-ng
    inputs.prismlauncher.packages.${pkgs.system}.prismlauncher
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
