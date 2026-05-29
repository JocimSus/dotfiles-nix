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
      options snd_hda_intel power_save=0
      options snd_sof_pci_intel_tgl power_save=0 
    '';
    # for xbox controller
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

  ## Desktop ##
  services.xserver = {
    enable = true;
  };
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  programs.hyprland.enable = true;

  ## Graphics ##
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
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

  system.stateVersion = "24.11"; # Do not change
}
