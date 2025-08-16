{
    pkgs,
    ...
}: {
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

  services.tlp = {
    enable = true;
    settings = {
      TLP_DEFAULT_MODE = "BAT";
      TLP_PERSISTENT_DEFAULT = 1;
      START_CHARGE_THRESH_BAT0 = "0";
      STOP_CHARGE_THRESH_BAT0  = "1";
    };
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "jocim-server";

  services.logind.lidSwitchExternalPower = "ignore";

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  ## Networking ##
  networking.resolvconf.enable = false;
  networking.networkmanager.enable = true;
  networking.nameservers = [ "94.140.14.14" ];
  services.resolved = {
    enable = true;
    dnsovertls = "true";
    fallbackDns = [ "94.140.15.15" "1.1.1.1" "1.0.0.1" ];
  };

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
    experimental-features = [ "nix-command" "flakes" ];
  };
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  system.stateVersion = "24.11"; # Do not change
}
