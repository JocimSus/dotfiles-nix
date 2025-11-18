{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Boot
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

    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "mem_sleep_default=deep"
      "sysrq_always_enabled=1"
    ];
    kernelModules = [
      "kvm-intel"
      "msi-ec"
    ];
    extraModulePackages = with config.boot.kernelPackages; [
      msi-ec
      xpadneo # xbox
    ];
    extraModprobeConfig = ''
      options bluetooth disable_ertm=Y
    ''; # for xbox controller
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024;
    }
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="leds", KERNEL=="platform::micmute", RUN+="${pkgs.coreutils}/bin/chmod 660 /sys/class/leds/%k/brightness"
    SUBSYSTEM=="leds", KERNEL=="platform::micmute", RUN+="${pkgs.coreutils}/bin/chown root:msi /sys/class/leds/%k/brightness"
    SUBSYSTEM=="leds", KERNEL=="platform::mute", RUN+="${pkgs.coreutils}/bin/chmod 660 /sys/class/leds/%k/brightness"
    SUBSYSTEM=="leds", KERNEL=="platform::mute", RUN+="${pkgs.coreutils}/bin/chown root:msi /sys/class/leds/%k/brightness"
  '';

  ## Networking ##
  networking.networkmanager.enable = true;
  # campus doesnt allow proxy/dns
  # networking.nameservers = [
  #   "94.140.14.14"
  #   "1.1.1.1"
  # ];
  # services.resolved = {
  #   enable = true;
  #   dnsovertls = "true";
  #   fallbackDns = [
  #     "94.140.15.15"
  #     "1.1.1.1"
  #     "1.0.0.1"
  #   ];
  # };

  ## Desktop ##
  services.xserver = {
    enable = true;
  };
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  programs.hyprland.enable = true;

  ## Timezone, locales ##
  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  # Sync time with windows, causes problems on linux
  # time.hardwareClockInLocalTime = true;

  ## Hardware ##
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      experimental = true; # show battery
      # https://www.reddit.com/r/NixOS/comments/1ch5d2p/comment/lkbabax/
      # for pairing bluetooth controller
      ControllerMode = "dual";
      Privacy = "device";
      JustWorksRepairing = "confirm";
      Class = "0x000100";
      FastConnectable = true;
    };
  };
  hardware.xpadneo.enable = true; # Enable the xpadneo driver for Xbox One wireless controllers
  hardware.xone.enable = true;

  ## Audio ##
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    extraConfig = {
      pipewire."92-fix-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 256;
          "default.clock.min-quantum" = 256;
          "default.clock.max-quantum" = 256;
        };
      };
    };
  };

  ## Graphics ##
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false; # needs to be closed source for NVENC
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      offload.enable = true;
      offload.enableOffloadCmd = true;
      sync.enable = false;
    };
  };

  specialisation = {
    desktop.configuration = {
      system.nixos.tags = [ "desktop" ];

      hardware.nvidia.prime = {
        offload.enable = lib.mkForce false;
        offload.enableOffloadCmd = lib.mkForce false;
        sync.enable = lib.mkForce true;
      };
    };
  };

  ## NixOS settings ##
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    download-buffer-size = 500000000;
  };
  # nix.gc = {
  #   automatic = true;
  #   dates = "daily";
  #   options = "--delete-older-than 7d";
  # };

  system.stateVersion = "24.11"; # Do not change
}
