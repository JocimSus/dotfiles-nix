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

  ## System ##
  swapDevices = [{
    device = "/swapfile";
    size = 16 * 1024;
  }];

  # fix permissions for msi-shit not able to write brightness file
  # IMPORTANT: add your user to msi-shit group
  # Been working for a while now
  services.udev.extraRules = ''
    SUBSYSTEM=="leds", KERNEL=="platform::micmute", RUN+="${pkgs.coreutils}/bin/chmod 660 /sys/class/leds/%k/brightness"
    SUBSYSTEM=="leds", KERNEL=="platform::micmute", RUN+="${pkgs.coreutils}/bin/chown root:msi-shit /sys/class/leds/%k/brightness"
    SUBSYSTEM=="leds", KERNEL=="platform::mute", RUN+="${pkgs.coreutils}/bin/chmod 660 /sys/class/leds/%k/brightness"
    SUBSYSTEM=="leds", KERNEL=="platform::mute", RUN+="${pkgs.coreutils}/bin/chown root:msi-shit /sys/class/leds/%k/brightness"
  '';


  boot.extraModulePackages = [ config.boot.kernelPackages.msi-ec ];
  boot.kernelModules = [ "kvm-intel" "msi-ec" ];

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

  services.printing = {
      enable = true;
      # hplipWithPlugin is proprietary (tried)
      # hplip is open source (tried and got cooked)
      drivers = [ pkgs.hplip ];
  };

  services.ipp-usb.enable = true;

  ## User account ##
  users.groups.msi-shit = {};

  networking.hostName = "meow";
  users.users.jocim-nix = {
    isNormalUser = true;
    description = "jocim-nix";
    extraGroups = [ "networkmanager" "wheel" "msi-shit" ];
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

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        runAsRoot = true;         # Required for system-level VMs
        swtpm.enable = true;      # Optional: TPM support for windwos 11 i think
      };
    };
  };

  programs.obs-studio = {
    enable = true;
  };

  fonts.packages = with pkgs; [ 
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
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
      # meowskers here
      pip
    ]))

    tmux
    btop
    neovim
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
    vscode

    qdirstat
    zoom-us

    # KDE Shit
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
