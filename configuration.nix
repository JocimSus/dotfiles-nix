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
  boot = {
    loader = {
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
    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = [
      "amdgpu.dc=1"
      "amdgpu.dpm=1"
      "amd.max_cstate=1"
      "processor.max_cstate=1"
      "idle=poll"
    ];
    extraModprobeConfig = ''
      options snd_hda_intel power_save=0
    '';
  };
  powerManagement.cpuFreqGovernor = "performance";

  ## Networking ##
  networking.networkmanager.enable = true;
  networking.hostName = "beam";
  services.resolved.enable = true;

  environment.etc."systemd/resolved.conf".text = ''
    [Resolve]
    DNS=1.1.1.1
    FallbackDNS=1.0.0.1
    DNSOverTLS=yes
  '';

  ## Graphics ##
  hardware.graphics = {
    enable = true;
  };

  ## Performance Tweaks ##
  zramSwap.enable = true;
  zramSwap.memoryPercent = 100;

  services.journald.extraConfig = ''
    Storage=volatile
    SystemMaxUse=50M
  '';

  ## Desktop ##
  environment.pathsToLink = [ "/libexec" ];
  hardware.opentabletdriver ={
    enable = true;
    daemon.enable = true;
  };
  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
  };

  ## Timezone, locales ##
  services.timesyncd.enable = true;
  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Sync time with windows
  time.hardwareClockInLocalTime = true;

  ## Services ##
  services.printing.enable = false;
  services.avahi.enable = false;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    audio.enable = true;

    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 48;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 48;
      };
    };
  };
  environment.etc."wireplumber/wireplumber.conf.d/50-alsa-config.conf".text = ''
    monitor.alsa.rules = [
      {
        matches = [
          {
            node.name = "~alsa_output.*"
          }
        ]
        actions = {
          update-props = {
            api.alsa.period-size = 1024
            api.alsa.headroom = 8192
          }
        }
      }
    ]
  '';

  environment.etc."wireplumber/wireplumber.conf.d/50-alsa-suspend.conf".text = ''
    monitor.alsa.rules = [
      {
        matches = [
          {
            node.name = "~alsa_output.*"
          }
        ]
        actions = {
          update-props = {
            session.suspend-timeout-seconds = 0
          }
        }
      }
    ]
  '';
  services.seatd.enable = true;
  services.xserver = {
    enable = true;
    windowManager.bspwm.enable = true;
  };
  services.displayManager.ly.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;

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
    # foot
    # mako
    kitty
    dunst
    wget
    unzip
    p7zip
    htop
    nemo-with-extensions
    bspwm
    sxhkd
    ly
    usbutils
    udiskie
    udisks
    toybox
    pciutils
  ];

  # nmcli dev wifi connect "vivo 1938" --ask

  system.stateVersion = "24.11"; # Do not change

  ## NixOS settings ##
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
    substituters = ["https://nix-gaming.cachix.org"];
    trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

}
