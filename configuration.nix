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

  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
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
  services.seatd.enable = true;
  services.xserver.enable = true;

  ## User account ##
  users.users.kaupec1 = {
    isNormalUser = true;
    description = "kaupec1";
    extraGroups = [ "networkmanager" "wheel" "video" "seat" ];
  };

  ## System programs ##
  programs.steam.enable = true;
  programs.light.enable = true;

  environment.systemPackages = with pkgs; [
    efibootmgr
    git
    foot
    mako
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
