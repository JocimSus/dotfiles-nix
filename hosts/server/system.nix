# Low level system settings, power management, bootloader, and garbage collection.
{
  pkgs,
  ...
}:
{
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
      };
    };

    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = [
      "amdgpu.dc=1"
      "amdgpu.dpm=1"
      "amd.max_cstate=1"
      "processor.max_cstate=1"
      "idle=poll"
      "mem_sleep_default=deep"
    ];
    extraModprobeConfig = ''
      options snd_hda_intel power_save=0
    '';
  };

  services.journald.extraConfig = ''
    Storage=volatile
    SystemMaxUse=50M
  '';

  powerManagement.cpuFreqGovernor = "performance";

  # Preserves battery life by limiting charge thresholds to 100% on AC power
  services.tlp = {
    enable = true;
    settings = {
      TLP_DEFAULT_MODE = "BAT";
      TLP_PERSISTENT_DEFAULT = 1;
      START_CHARGE_THRESH_BAT0 = "0";
      STOP_CHARGE_THRESH_BAT0 = "1";
    };
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "jocim-server";

  # Prevents the laptop server from sleeping when the lid is closed
  services.logind.lidSwitchExternalPower = "ignore";

  # Forcibly disable all sleep/suspend states to ensure 100% server uptime
  systemd.sleep.settings.Sleep = {
    AllowSuspend = "no";
    AllowHibernation = "no";
    AllowHybridSleep = "no";
    AllowSuspendThenHibernate = "no";
  };

  ## Networking ##
  networking.networkmanager.enable = true;

  ## Timezone, locales ##
  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  ## NixOS settings ##
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  system.stateVersion = "24.11"; # Do not change
}
