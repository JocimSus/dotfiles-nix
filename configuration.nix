{
  inputs,
  config,
  pkgs,
  stdenv,
  callPackage,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
    ];

    # Bootloader
    boot.loader = {
        efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot";
        };
        grub = {
            enable = true;
            efiSupport = true;
            device = "nodev";
            useOSProber = true;
        };
    };

  ## Networking ##
  networking.networkmanager.enable = true;
  networking.hostName = "beam";

  ## Graphics ##
  hardware.graphics = {
    enable = true;
  };

  ## Desktop ##
  environment.pathsToLink = [ "/libexec" ];

  # security.polkit.enable = true;

  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
  };

  #wayland.windowManager.sway = {
  #  enable = true;
  #  config = rec {
  #    modifier = "Mod4";
  #    terminal = "kitty";
  #    startup = [
  #      # {command = "firefox";}
  #    ]
  #  };
  #};

  services.xserver = {
    enable = true;
    desktopManager.xterm.enable = false;
    displayManager.defaultSession = "none+i3";

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        rofi
        i3blocks
        i3lock
      ];
    };
  };

  ## Timezone, locales ##
  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Sync time with windows
  time.hardwareClockInLocalTime = true;

  ## Services ##
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  ## User account ##
  users.users.kaupec1 = {
    isNormalUser = true;
    description = "kaupec1";
    extraGroups = [ "networkmanager" "wheel" "video" ];
  };

  ## System programs ##
  programs.steam.enable = true;
  programs.light.enable = true;

  environment.systemPackages = with pkgs; [
    efibootmgr
    git
    kitty
  ];

  system.stateVersion = "24.11"; # Do not change

  ## NixOS settings ##
  nixpkgs.config.allowUnfree = true;
    nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

}
