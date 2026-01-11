{
  pkgs,
  pkgs-stable,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./system.nix
    ../../modules/msi-laptop
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

    package = pkgs.obs-studio.override {
      cudaSupport = true;
    };

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
    "ventoy-qt5-1.1.10"
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

  ## Environment ##
  # libmagic please man
  environment.extraOutputsToInstall = [ "dev" ];

  environment.variables = {
    C_INCLUDE_PATH = "${pkgs.file.dev}/include";
    LIBRARY_PATH = "${pkgs.file.dev}/lib";
    # EDITOR = "nvim";
  };

  environment.systemPackages = with pkgs; [
    ## Low Level ##
    efibootmgr
    gparted
    ventoy-full-qt
    popsicle
    clang-tools
    man-pages
    file
    gcc
    gdb
    ghidra-bin

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
    ffmpeg-full
    aria2
    jq
    wl-clipboard
    speedtest-cli
    nixfmt-rfc-style
		ani-cli

    jdk25
    (python312.withPackages (
      ps: with ps; [
        pip
        flask
        pyyaml
        tkinter
        six
        debugpy # nvim python debugging plugin
      ]
    ))
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
    pnpm
    imagemagick

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
    # guvcview # disabling for now as it cannot build
    # fluffychat
    gnome-tweaks
    # davinci-resolve
    # breaks github workflow because davinci-resolve is an appimage
    # Steps to fix:
    # 1. disable nix gc
    # 2. remove this package
    google-chrome
    nextcloud-client
    # obsidian
    pkgs-stable.obsidian
    logisim-evolution
    android-studio
    postman
    looking-glass-client

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
    protonup-ng
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
