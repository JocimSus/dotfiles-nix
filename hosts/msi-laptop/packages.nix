# Global system-wide package and program definitions.
{
  pkgs,
  pkgs-25_05,
  inputs,
  ...
}:
{
  ## Programs ##
  # System-level programs that require root/daemon privileges
  virtualisation.docker.enable = true;

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
  programs.nix-ld.enable = true;
  programs.kdeconnect.enable = true;

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

  ## Insecure ##
  nixpkgs.config.permittedInsecurePackages = [
    # "ventoy-qt5-1.1.10"
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
    biome
    prisma_6
    prisma-engines_6

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
    kdePackages.konversation

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
    motrix-next

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
  ];

  ## WORKAROUNDS ##
  nixpkgs.overlays = [
    # openldap
    (final: prev: {
      openldap =
        if prev.stdenv.hostPlatform.system == "i686-linux" then
          prev.openldap.overrideAttrs (oldAttrs: {
            doCheck = false;
          })
        else
          prev.openldap;
    })
  ];
}
