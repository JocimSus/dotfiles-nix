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
	    START_CHARGE_THRESH_BAT1 = 40; #start charge at 40
	    STOP_CHARGE_THRESH_BAT1 = 80; #stop charge at 80
	    
	    #stops overheating while plugged in
	    TLP_DEFAULT_MODE = "BAT";
	    TLP_PERSISTENT_DEFAULT = 1; 
	};
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
        experimental-features = [ "nix-command" "flakes" ];
    };
    nix.gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
    };

    system.stateVersion = "24.11"; # Do not change
}
