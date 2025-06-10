{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
      ../common.nix
    ];

  ## System ##
  swapDevices = [{
    device = "/swapfile";
    size = 16 * 1024;
  }];

  # IMPORTANT: add your user to msi-shit group
  services.udev.extraRules = ''
    SUBSYSTEM=="leds", KERNEL=="platform::micmute", RUN+="${pkgs.coreutils}/bin/chmod 660 /sys/class/leds/%k/brightness"
    SUBSYSTEM=="leds", KERNEL=="platform::micmute", RUN+="${pkgs.coreutils}/bin/chown root:msi-shit /sys/class/leds/%k/brightness"
    SUBSYSTEM=="leds", KERNEL=="platform::mute", RUN+="${pkgs.coreutils}/bin/chmod 660 /sys/class/leds/%k/brightness"
    SUBSYSTEM=="leds", KERNEL=="platform::mute", RUN+="${pkgs.coreutils}/bin/chown root:msi-shit /sys/class/leds/%k/brightness"
  '';

  boot.extraModulePackages = [ config.boot.kernelPackages.msi-ec ];
  boot.kernelModules = [ "kvm-intel" "msi-ec" ];

  services.printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
  };
  services.ipp-usb.enable = true;
  ## Graphics ##
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      sync.enable = true;   
    };
  };

  specialisation = {
    on-the-go.configuration = {
      system.nixos.tags = [ "on-the-go" ];
      hardware.nvidia = {
        prime.offload.enable = lib.mkForce true;
        prime.offload.enableOffloadCmd = lib.mkForce true;
        prime.sync.enable = lib.mkForce false;
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
    trusted-substituters = [ 
      "https://prismlauncher.cachix.org"
    ];
  };

  ## User account ##
  users.groups.msi-shit = {};

  networking.hostName = "meow";
  users.users.jocim-nix = {
    isNormalUser = true;
    description = "jocim-nix";
    extraGroups = [ "networkmanager" "wheel" "video" "msi-shit" ];
  };
  users.defaultUserShell = pkgs.zsh;

  ## System programs ##
  services.flatpak.enable = true;
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;
  programs.zsh.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        runAsRoot = true;         # Required for system-level VMs
        swtpm.enable = true;      # Optional: TPM support for windwos 11 i think
      };
    };
  };

  fonts.packages = with pkgs; [ 
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    nerd-fonts.fantasque-sans-mono
  ];

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

    jdk17
    (python312.withPackages (ps: with ps; [ 
      pip
    ]))

    btop-cuda
    lunarvim

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
    xsane
    kdePackages.skanpage

    # Documents and Books
    calibre
    onlyoffice-desktopeditors

    ## Virtualization ##
    qemu
    virt-manager
    libvirt

    ## Gaming ##
    protontricks
    vulkan-tools
    lutris
    mangohud
    protonup
  ];
}
